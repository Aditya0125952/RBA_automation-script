import { BasePage } from "./BasePage.page";

export class AddressRekyc extends BasePage{
    async AddressRekycScreev(){
        await this.page.waitForLoadState('networkidle');
        const continueBtn = this.page.getByRole('button', { name: 'Continue' });
        await continueBtn.waitFor({state:'visible'});
        await continueBtn.click();
        const addressInput = this.page.locator('#billing-address-1');
        await addressInput.waitFor({ state: 'visible' });
        const allFormInputs = this.page.locator('input');
        const currenturl = await this.page.url();
        const parse = new URL(currenturl);
        const type = parse.searchParams.get("type");
        if(type != "CO_APPLICANT"){
        await allFormInputs.nth(0).fill('11765 West Avenue');
        await allFormInputs.nth(2).fill('San Antonio');
        await this.page.waitForTimeout(500);
        await allFormInputs.nth(3).fill('Iowa');
        await allFormInputs.nth(3).press('Enter');
        await allFormInputs.nth(4).fill('50011');
        }
    }
}