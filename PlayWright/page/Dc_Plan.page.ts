import { BasePage } from "./BasePage.page";
import { showDecisionModal } from "../utils/interactiveDecisionModal";

type PlanItem = {
  name: string;
};

export class Dc_Plan_Page extends BasePage {

  async Dc_Plan_Selection(Plan?: string) {
    console.log("Waiting for plans API...");

    const [plansResponse] = await Promise.all([
      this.page.waitForResponse(
        resp => resp.url().includes("plans") && resp.ok()
      ),
      this.page.waitForLoadState("networkidle"),
    ]);

    const plansData = await plansResponse.json();

    // ---------- FLATTEN API RESPONSE ----------
    const plans: PlanItem[] =
      plansData?.result?.plans?.flatMap((group: any) =>
        group.plans.map((p: any) => ({
          name: p.name,
        }))
      ) || [];

    // ---------- NO PLANS → AUTO FLOW ----------
    if (plans.length === 0) {
      console.log(
        "ℹ️ No plans returned. Plan selection skipped (auto-assigned / master flow)."
      );
      return;
    }

    // ---------- NO PLAN PROVIDED → PICK FIRST ----------
    if (!Plan) {
      console.log(
        "No plan provided. Selecting first available plan:",
        plans[0].name
      );
      await this.selectPlan(plans[0].name);
      await this.fillAmountsAndContinue();
      return;
    }

    // ---------- EXACT MATCH ONLY ----------
    const exactMatch = plans.find(p => p.name === Plan);

    if (exactMatch) {
      console.log("Exact plan match found:", exactMatch.name);
      await this.selectPlan(exactMatch.name);
      await this.fillAmountsAndContinue();
      return;
    }

    // ---------- PLAN NOT FOUND → INTERACTIVE MODAL ----------
    const decision = await showDecisionModal(this.page, {
      title: "Plan Not Found",
      message: `The plan "<b>${Plan}</b>" is not available.`,
      dropdownLabel: "Available plans",
      options: plans.map(p => p.name),
      timeoutMs: 20000,
      continueText: "Continue",
      cancelText: "No",
    });

    if (decision.action === "cancel") {
      console.log("User cancelled plan selection");
      console.log("Current URL:", decision.url);
      await this.page.context().close();
      return;
    }

    // ---------- USER SELECTED PLAN ----------
    await this.selectPlan(decision.value!);
    console.log("User selected plan:", decision.value);

    await this.fillAmountsAndContinue();
  }

  // ---------- HELPERS ----------

  private async selectPlan(planName: string) {
    await this.page.locator(`b:has-text("${planName}")`).click();
  }

  private async fillAmountsAndContinue() {
    await this.page
      .locator(
        'div.CLS-input-group:has(p:has-text("Enter Project Cost")) input'
      )
      .fill("21000");

    await this.page
      .locator(
        'div.CLS-input-group:has(p:has-text("Enter Deposit Amount")) input'
      )
      .fill("0");

    await this.page.getByRole("button", { name: "Continue" }).click();
  }
}
