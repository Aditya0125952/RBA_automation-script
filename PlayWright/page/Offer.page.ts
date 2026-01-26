import { showDecisionModal } from "../utils/interactiveDecisionModal";
import { BasePage } from "./BasePage.page";
import { TilaStrategyResolver } from "./TILA/Core/TilaStrategyResolver";
import { LENDER_NAME_MAP } from "./TILA/Interface/LenderMapping";

export class OfferPage extends BasePage {

  private offersResponse: any;

  async waitForOffers(timeoutMs = 160000,expectedLender: string): Promise<any> {
    const url = this.page.url();
    const loanId = new URL(this.page.url()).searchParams.get('loanId');
    console.log("this is the Offer generation URL:", url);
    console.log("🔄 Waiting for Loan Offers API...");

    const response = await this.page.waitForResponse(
      async (res) => {
        if (
          !res.url().includes("/loan-applications/") ||
          !res.url().endsWith("/offers") ||
          res.request().method() !== "GET"
        ) {
          return false;
        }

        try {
          const json = await res.json();
          const loanStatus = json?.result?.loanStatus;
          const offers = json?.result?.offers ?? [];

          console.log(
            `📡 Offers API → loanStatus=${loanStatus}, offers=${offers.length}`
          );

          return loanStatus === "OFFERS_RECEIVED" && offers.length > 0;
        } catch {
          return false;
        }
      },
      { timeout: timeoutMs }
    );

    this.offersResponse = await response.json();
    const offers = this.offersResponse?.result?.offers;
    if (!offers || offers.length === 0) {
      throw new Error("Offers API returned but no offers found");
    }

    console.log(`✅ Offers received successfully: ${offers.length}`);
    console.log("Offer From :", offers[0].portalName);
    const mappedExpectedLender = LENDER_NAME_MAP[expectedLender];
    if (offers[0].portalName !== mappedExpectedLender) {
       const decision = await showDecisionModal(this.page,{
          title: `${offers[0].portalName} Offer`,
          message: `We found an offer from a different lender than the one you selected.

          Selected lender:
          ${mappedExpectedLender}

          Offer received from:
          ${offers[0].portalName}

          Would you like to continue with this offer?`,
          loanId: `${loanId}`,
          timeoutMs: 15000,
          continueText: "Continue",
          cancelText: "Cancel",
        });

        if (decision.action === "cancel"){
          console.log("User cancelled the automation flow due to lender mismatch");
          await this.page.context().close();
          return; 
        }else{
          console.log("User chose to continue despite lender mismatch");
        }

    }else{
      console.log("Lender matched successfully");
    }

    return this.offersResponse;
  }

  // Click Continue → Navigate to TILA → Execute lender-specific TILA
  async continueToTilaAndSign(): Promise<void> {

    if (!this.offersResponse) {
      throw new Error(
        "Offers not loaded. Call waitForOffers() before continueToTilaAndSign()"
      );
    }

    console.log("➡️ Clicking Continue on Offers page");

    // 1️⃣ Click Continue
    await this.page.getByRole("button", { name: "Continue" }).click();

    // 3️⃣ Resolve lender
    const lenderName = this.offersResponse.result.offers[0].portalName;
    console.log(`🏦 Navigated to TILA for lender: ${lenderName}`);

    // 4️⃣ Execute lender-specific TILA
    const tila = TilaStrategyResolver.resolve(lenderName, this.page);
    await tila.sign();
  }
}
