import { TestGlobalData } from "../Interface/statcDataContainer";
import { BasePage } from "./BasePage.page";
import { ApplicantData } from "../Interface/interface.js";
import { Locator } from "@playwright/test";

export class BasicInformationPage extends BasePage{

async BasicInformationPage(){
    
    const applicant : ApplicantData = TestGlobalData.applicantData;
    const coApplicant : ApplicantData | null = TestGlobalData.coApplicantData;

    await this.page.waitForLoadState('networkidle');
    const allFormInputs = this.page.locator('input');
    const currenturl = await this.page.url();
    const parse = new URL(currenturl);
    const type = parse.searchParams.get("type");
    if(type != "CO_APPLICANT"){
        await allFormInputs.nth(4).fill(applicant.dob);
        await this.page.keyboard.press('Enter');
        await allFormInputs.nth(10).fill(applicant.Do_you_own_installation_add);
        await this.page.keyboard.press('Enter');
        await allFormInputs.nth(11).fill(applicant.Do_you_reside_installation_add);
        await this.page.keyboard.press('Enter');
        await this.page.locator(`#check`).check();
    }else{
        await allFormInputs.nth(4).fill(coApplicant.dob);
        await this.page.keyboard.press('Enter');
        await allFormInputs.nth(10).fill(coApplicant.Do_you_own_installation_add);
        await this.page.keyboard.press('Enter');
        await allFormInputs.nth(11).fill(coApplicant.Do_you_reside_installation_add);
        await this.page.keyboard.press('Enter');
        await allFormInputs.nth(13).fill(coApplicant.street_add);
        await allFormInputs.nth(15).fill(coApplicant.city);
        await this.page.waitForTimeout(500);
        await allFormInputs.nth(16).fill(coApplicant.state);
        await allFormInputs.nth(16).press('Enter');
        await allFormInputs.nth(17).fill(coApplicant.zipcode);
    }
    
    const continueBtn = this.page.getByRole('button',{name:'Continue'});
    await continueBtn.waitFor({state : 'visible'});
    while(1){
        const [response] = await Promise.all([
                this.page.waitForResponse('**/process-payload?**'),
                continueBtn.click(),
            ]);
            const data = await response.json();
            if (data.meta.success && data.meta.code === 200){
                console.log('Basic Details successful');
                break;
            }else{
                await this.page.waitForTimeout(1000);
            }

    }
}

}