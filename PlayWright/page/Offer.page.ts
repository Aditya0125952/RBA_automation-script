import { BasePage } from "./BasePage.page";

export class OfferPage extends BasePage {

  /**
   * Waits until offers are fully available
   * 1️⃣ run-identifier confirms OFFERS_RECEIVED
   * 2️⃣ offers API returns offers[]
   */
  async waitForOffers(timeoutMs = 120000): Promise<void> {
    console.log("🔄 Waiting for run-identifier (EDGE)...");

    // ─────────────────────────────────────────────
    // STEP 1: run-identifier (workflow-engine)
    // ─────────────────────────────────────────────
    await this.page.waitForResponse(
      async (res) => {
        if (
          !res.url().includes("/workflow-engine/run") ||
          res.request().method() !== "GET"
        ) {
          return false;
        }

        try {
          const json = await res.json();

          const loanStatus =
            json?.result?.facts?.["loan.status"];

          const offerCount =
            json?.result?.facts?.["loan.offers.available_offers"] ?? 0;

          console.log(
            `📡 run-identifier → loan.status=${loanStatus}, available_offers=${offerCount}`
          );

          return loanStatus === "OFFERS_RECEIVED" && offerCount > 0;
        } catch {
          return false;
        }
      },
      { timeout: timeoutMs }
    );

    console.log("✅ run-identifier confirmed OFFERS_RECEIVED");

    // ─────────────────────────────────────────────
    // STEP 2: offers API (actual offers payload)
    // ─────────────────────────────────────────────
    console.log("🔄 Waiting for offers API...");

    await this.page.waitForResponse(
      async (res) => {
        if (
          !res.url().includes("/offers") ||
          res.request().method() !== "GET"
        ) {
          return false;
        }

        try {
          const json = await res.json();

          const loanStatus = json?.loanStatus;
          const offersCount = json?.offers?.length ?? 0;

          console.log(
            `📡 offers API → loanStatus=${loanStatus}, offers=${offersCount}`
          );

          return loanStatus === "OFFERS_RECEIVED" && offersCount > 0;
        } catch {
          return false;
        }
      },
      { timeout: timeoutMs }
    );

    console.log("✅ Offers API returned offers");
  }
}
