
import { BasePage } from "./BasePage.page";


export class Dc_Plan_Page extends BasePage{

    async Dc_Plan_Selection(Code?:String){
        await Promise.all([
            this.page.waitForResponse(resp =>
                //resp.url().includes('9106.js') && resp.ok()
                resp.url().includes('plans') && resp.ok()
            ),
            this.page.waitForLoadState('networkidle')
        ]);
        //await this.page.locator(`#${Code}`).click();
        await this.page.locator(`b:has-text("${Code}")`).click();
        await this.page.locator('div.CLS-input-group:has(p:has-text("Enter Project Cost")) input').fill('21000');
        await this.page.locator('div.CLS-input-group:has(p:has-text("Enter Deposit Amount")) input').fill('0');
        await this.page.getByRole('button',{name: 'Continue'}).click();
    }
}