import { Locator, Page, expect } from "@playwright/test";
import Fuse from "fuse.js";
import { BasePage } from "./BasePage.page";
import { showDecisionModal } from "../utils/interactiveDecisionModal";
export class MerchantSelectionAndLocationPage extends BasePage {
    readonly LoginButton: Locator;
    constructor() {
        super();
        this.LoginButton = this.page.getByRole('button', { name: 'Submit' });
    }
    async MerchantAndLocationSelection(Merchant: string, Location?: string) {
  console.log(`Waiting for merchant list API and clicking submit...`);

  const [response] = await Promise.all([
    this.page.waitForResponse('**/api/pos/login/merchants'),
    this.LoginButton.click(),
  ]);

  if (!response.ok()) {
    throw new Error(`API call failed with status: ${response.status()}`);
  }

  const data = await response.json();

  if (!data?.users || !Array.isArray(data.users)) {
    throw new Error('Invalid merchant API response');
  }

  // ---------- MERCHANT FUZZY MATCH ----------
  const merchantFuse = new Fuse(data.users, {
    keys: ['merchantName'],
    threshold: 0.3,
  });

  const merchantResult = merchantFuse.search(Merchant);

  if (merchantResult.length === 0) {
    throw new Error(`Merchant '${Merchant}' not found`);
  }

  const foundMerchant = merchantResult[0].item.merchantName;
  console.log('Selected merchant:', foundMerchant);

  // ---------- FETCH LOCATIONS ----------
  const [locationResponse] = await Promise.all([
    this.page.waitForResponse('**/api/pos/merchant/login'),
    this.page.selectOption('select.login-selectdropdown', {
      label: foundMerchant,
    }),
  ]);

  const locationData = await locationResponse.json();

  const locations =
    locationData?.merchantUser?.userLocationConfigs?.map(
      (l: any) => l.locationName
    ) || [];

  if (!locations || locations.length === 0) {
  console.log(
    'ℹ️ No locations returned. Merchant is MASTER user. Skipping location selection.'
  );
  return; // ← IMPORTANT
}

  // ---------- IF NO LOCATION PASSED → AUTO PICK FIRST ----------
  if (!Location) {
    await this.page.selectOption('select.login-selectdropdown', {
      label: locations[0],
    });
    return;
  }

  // ---------- LOCATION FUZZY MATCH ----------
  const locationFuse = new Fuse(locations, { threshold: 0.3 });
  const locationResult = locationFuse.search(Location);

  if (locationResult.length > 0) {
    const matchedLocation = locationResult[0].item;
    console.log('Matched location:', matchedLocation);

    await this.page.selectOption('select.login-selectdropdown', {
 label: matchedLocation,
    });
    return;
  }

  // ---------- LOCATION NOT FOUND → SHOW MODAL ----------
  const decision = await showDecisionModal(this.page, {
    title: 'Location Not Found',
    message: `The location "<b>${Location}</b>" is not available for merchant "<b>${foundMerchant}</b>".`,
    dropdownLabel: 'Available locations',
    options: locations,
    continueText: 'Continue',
    cancelText: 'No',
  });

  if (decision.action === 'cancel') {
    console.log('User cancelled flow at location selection');
    console.log('Current URL:', decision.url);
    return decision.url;
  }

  // ---------- USER SELECTED NEW LOCATION ----------
  await this.page.selectOption('select.login-selectdropdown', {
    label: decision.value!,
  });

  console.log('User selected new location:', decision.value);
}

}