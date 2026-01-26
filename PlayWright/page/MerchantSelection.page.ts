import { Locator } from "@playwright/test";
import Fuse from "fuse.js";
import { BasePage } from "./BasePage.page";
import { showDecisionModal } from "../utils/interactiveDecisionModal";

export class MerchantSelectionAndLocationPage extends BasePage {
  readonly loginButton: Locator;

  constructor() {
    super();
    this.loginButton = this.page.getByRole("button", { name: "Submit" });
  }

  async MerchantAndLocationSelection(
    merchantName: string,
    locationName?: string
  ) {
    console.log("🔄 Waiting for merchant list API and submitting login");

    /* ------------------ FETCH MERCHANTS ------------------ */
    const [merchantResponse] = await Promise.all([
      this.page.waitForResponse("**/api/pos/login/merchants"),
      this.loginButton.click(),
    ]);

    if (!merchantResponse.ok()) {
      throw new Error(
        `Merchant API failed with status ${merchantResponse.status()}`
      );
    }

    const merchantData = await merchantResponse.json();

    if (!Array.isArray(merchantData?.users)) {
      throw new Error("Invalid merchant API response");
    }

    /* ------------------ MERCHANT FUZZY MATCH ------------------ */
    const merchantFuse = new Fuse(merchantData.users, {
      keys: ["merchantName"],
      threshold: 0.3,
    });

    const merchantMatch = merchantFuse.search(merchantName);
    if (merchantMatch.length === 0) {
      throw new Error(`Merchant '${merchantName}' not found`);
    }

    const selectedMerchant = merchantMatch[0].item.merchantName;
    console.log("✅ Selected merchant:", selectedMerchant);

    /* ------------------ FETCH LOCATIONS ------------------ */
    const [locationResponse] = await Promise.all([
      this.page.waitForResponse("**/api/pos/merchant/login"),
      this.page.selectOption("select.login-selectdropdown", {
        label: selectedMerchant,
      }),
    ]);

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

    /* ------------------ AUTO PICK FIRST LOCATION ------------------ */
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

    /* ------------------ LOCATION NOT FOUND → MODAL ------------------ */
    console.log("⚠️ Location not found. Asking user.");

    const decision = await showDecisionModal(this.page, {
      title: "Location Not Found",
      message: `The location "${locationName}" is not available for merchant "${selectedMerchant}".`,
      dropdownLabel: "Available locations",
      options: locations,
      timeoutMs: 10000,
      continueText: "Continue",
      cancelText: "No",
    });

    /* 🔑 Ensure modal overlay is fully removed */
    await this.page.waitForSelector(
      "#automation-decision-modal-root",
      { state: "detached" }
    );

    /* ------------------ USER CANCEL / TIMEOUT ------------------ */
    if (decision.action === "cancel") {
      console.log("🚫 Location selection cancelled (user or timeout)");
      await this.page.context().close();
      return;
    }

    /* ------------------ SAFETY CHECK ------------------ */
    if (!decision.value) {
      console.log("⚠️ No location selected from modal");
      return;
    }

    /* ------------------ APPLY USER SELECTION ------------------ */
    await this.page.selectOption("select.login-selectdropdown", {
      label: decision.value,
    });

    console.log("✅ User selected new location:", decision.value);
  }
}
