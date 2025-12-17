import { stat } from "fs";
import { BasePage } from "./BasePage.page";

export class Credit_Freeze_Page extends BasePage{

    async Credit_Freeze_Details(){
            await this.page.waitForLoadState('networkidle');
            const continueButton = this.page.getByRole('button', { name: 'Continue' });
            await continueButton.waitFor({state : "visible"});
            await continueButton.click();
    }

}