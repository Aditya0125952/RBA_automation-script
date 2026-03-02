import { Locator } from "@playwright/test";
import Fuse from "fuse.js";
import { BasePage } from "./BasePage.page";
import { showDecisionModal } from "../utils/interactiveDecisionModal";

export class MerchantSelectionAndLocationPage extends BasePage {
  async MerchantAndLocationSelection(
    merchantName: string,
    locationName?: string
  ) {
    console.log("🔄 Waiting for merchant list API results");

    /* ------------------ FETCH MERCHANTS ------------------ */
    const merchantResponse = await this.page.waitForResponse(
      "**/api/pos/login/merchants", 
      { timeout: 60000 }
    );

    if (!merchantResponse.ok()) {
      throw new Error(
        `Merchant API failed with status ${merchantResponse.status()}`
      );
    }

    const merchantData = await merchantResponse.json();
    const merchantUsers = merchantData?.users || [];

    if (merchantUsers.length === 0) {
      throw new Error("Invalid merchant API response: No users found.");
    }

    let selectedMerchant: string;

    /* ------------------ SMART MERCHANT SELECTION ------------------ */
    if (merchantUsers.length === 1) {
      // Scenario: One Merchant - Auto-pick and skip UI interaction
      selectedMerchant = merchantUsers[0].merchantName;
      console.log("✨ Only one merchant found. Skipping merchant selection UI:", selectedMerchant);
    } else {
      // Scenario: Multiple Merchants - Perform Fuzzy Match and Selection
      const merchantFuse = new Fuse(merchantUsers, {
        keys: ["merchantName"],
        threshold: 0.3,
      });

      const merchantMatch = merchantFuse.search(merchantName);
      if (merchantMatch.length === 0) {
        throw new Error(`Merchant '${merchantName}' not found`);
      }

      selectedMerchant = merchantMatch[0].item.merchantName;
      console.log("✅ Selected merchant from list:", selectedMerchant);

      // Select the option to trigger the location API
      await this.page.selectOption("select.login-selectdropdown", {
        label: selectedMerchant,
      });
    }

    /* ------------------ FETCH LOCATIONS ------------------ */
    // Note: If merchant was auto-picked, the API might already be in flight or finished.
    const locationResponse = await this.page.waitForResponse(
      "**/api/pos/merchant/login",
      { timeout: 30000 }
    );

    if (!locationResponse.ok()) {
      throw new Error(
        `Location API failed with status ${locationResponse.status()}`
      );
    }

    const locationData = await locationResponse.json();
    const locations: string[] =
      locationData?.merchantUser?.userLocationConfigs?.map(
        (l: any) => l.locationName
      ) || [];

    /* ------------------ MASTER USER (NO LOCATIONS) ------------------ */
    if (locations.length === 0) {
      console.log(
        "ℹ️ Merchant is MASTER user. Skipping location selection."
      );
      return;
    }

    /* ------------------ SMART LOCATION SELECTION ------------------ */
    if (locations.length === 1) {
      // Scenario: One Location - Auto-skip
      console.log("✨ Only one location found. Skipping location selection UI:", locations[0]);
      return;
    }

    // Scenario: Multiple Locations - logic follows
    /* ------------------ AUTO PICK FIRST LOCATION (If none provided) ------------------ */
    if (!locationName) {
      console.log("ℹ️ No location provided. Selecting first available.");
      await this.page.selectOption("select.login-selectdropdown", {
        label: locations[0],
      });
      return;
    }

    /* ------------------ LOCATION FUZZY MATCH ------------------ */
    const locationFuse = new Fuse(locations, { threshold: 0.3 });
    const locationMatch = locationFuse.search(locationName);

    if (locationMatch.length > 0) {
      const matchedLocation = locationMatch[0].item;
      console.log("✅ Matched location:", matchedLocation);

      await this.page.selectOption("select.login-selectdropdown", {
        label: matchedLocation,
      });
      return;
    }

    /* ------------------ MODAL WITH ERROR-RESISTANT FALLBACK ------------------ */
    console.log("⚠️ Location not matched. Triggering decision modal.");

    let decision;
    try {
      decision = await showDecisionModal(this.page, {
        title: "Location Not Found",
        message: `The location "${locationName || 'default'}" was not matched. Select one or wait for auto-pick.`,
        dropdownLabel: "Available locations",
        options: locations,
        timeoutMs: 10000,
        continueText: "Continue",
        cancelText: "No",
      });
    } catch (error) {
      // If showDecisionModal throws an error on timeout, we catch it here
      console.log("⏰ Modal timed out (Error Caught). Falling back to first location:", locations[0]);
      await this.page.selectOption("select.login-selectdropdown", { label: locations[0] });
      return; // Exit the function after applying fallback
    }

    if (decision.action === 'cancel' && decision.timedOut) {
    console.log("⏰ Timer expired. Falling back to first location.");
    await this.page.selectOption("select.login-selectdropdown", { label: locations[0] });
      } 
      // 2. Check for Explicit "No" Click
      else if (decision.action === 'cancel') {
          console.log("🚫 User clicked 'No'. Stopping execution.");
          await this.page.context().close();
          return;
      }
      // 3. Check for Continue
      else if (decision.action === 'continue') {
          await this.page.selectOption("select.login-selectdropdown", { label: decision.value });
      }
  }
}