import { BasePage } from "./BasePage.page";

export class ApplicantSelectionPage extends BasePage{
    
    async Applicant_Selection_Page(coAapp?:Boolean){
        await this.page.waitForLoadState('networkidle');
        await this.page.waitForTimeout(2000);
        const continueBtn = this.page.getByRole('button', { name: 'Continue' });

            // Wait for the button to be present & visible
            await continueBtn.waitFor({ state: 'visible' });
            if (coAapp){
                await this.page.click('text=YES');
            }else{
                // Wait until the button becomes ENABLED
            await this.page.waitForFunction(
                (btn) => btn && !btn.disabled,
                await continueBtn.elementHandle()
            );
            }

            

            // Click the button (no need for waitForNavigation unless page actually navigates)
            await continueBtn.click();




    }
}