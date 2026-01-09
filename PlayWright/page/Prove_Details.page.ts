import { log } from "console";
import { TestGlobalData } from "../Interface/statcDataContainer";
import { BasePage } from "./BasePage.page";
import { ApplicantData } from "../Interface/interface.js";


export class Prove_Details_Page extends BasePage {

    async Prove_Details(){

        const applicant : ApplicantData = TestGlobalData.applicantData;
        const coApplicant : ApplicantData | null = TestGlobalData.coApplicantData;

        const continuBtn = this.page.getByRole('button',{name : 'Continue'});
        await continuBtn.waitFor({state : 'visible'});
        const currenturl = await this.page.url();
        const parse = new URL(currenturl);
        const type = parse.searchParams.get("type");
        const inputFields = this.page.locator('input');
        if(type != "CO_APPLICANT"){
            await inputFields.nth(0).fill(applicant.ssn);
            await inputFields.nth(1).fill(applicant.mobileNumber);
        }else{
            await inputFields.nth(0).fill(coApplicant.ssn);
            await inputFields.nth(1).fill(coApplicant.mobileNumber);
        }
        while(1){
            const [response] = await Promise.all([
                this.page.waitForResponse('**/prefill-information?**'),
                continuBtn.click(),
            ]);
            const data = await response.json();

            if (data.meta.success && data.meta.code === 200){
                console.log('prefilling successful');
                break;
            }else{
                await this.page.waitForTimeout(1000);
            }
        
        }
    }
}