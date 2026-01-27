import { TestGlobalData } from "../Interface/statcDataContainer";
import { BasePage } from "./BasePage.page";
import { ApplicantData } from "../Interface/interface.js";

export class ApplicationDetailsPage extends BasePage{
    async Application_Details_Page(CoApp?:Boolean,lenderName?: string){

        const applicant: ApplicantData = TestGlobalData.applicantData;
        
        // Retrieve coApplicant data safely (it might be null)
        const coApplicant: ApplicantData | null = TestGlobalData.coApplicantData;

        await this.page.waitForSelector('text="Send Application"')
        const allInputs = this.page.locator('input, textarea, select');
        await allInputs.nth(0).fill(applicant.street_add);
        await allInputs.nth(2).fill(applicant.city);
        if(lenderName == "GICU" || lenderName == "PCU"){
            await allInputs.nth(3).fill('Iowa');
            await allInputs.nth(3).press('Enter');
            await allInputs.nth(4).fill('50014');
        }else{
            await allInputs.nth(3).fill(applicant.state);
            await allInputs.nth(3).press('Enter');
            console.log("zipcode :",applicant.zipcode);
            await allInputs.nth(4).fill(applicant.zipcode);
        }
        await allInputs.nth(5).fill(applicant.FirstName);
        await allInputs.nth(6).fill(applicant.LastName);
        await allInputs.nth(7).fill(applicant.Email);
        await allInputs.nth(8).fill(applicant.mobileNumber);
        if(CoApp){
            await allInputs.nth(9).waitFor({state: 'visible'});
            await allInputs.nth(9).fill(coApplicant.FirstName);
            await allInputs.nth(10).fill(coApplicant.LastName);
            await allInputs.nth(11).fill(TestGlobalData.applicantData.Email);
            await allInputs.nth(12).fill(coApplicant.mobileNumber);
        }
        const noOption = this.page.locator('label.selectable-option', { hasText: 'NO' });
        await noOption.waitFor({ state: 'visible' });
        await noOption.scrollIntoViewIfNeeded();
        await noOption.click();
        await this.page.keyboard.press('Enter');
        await this.page.getByRole('button', {name:'Send Application'}).click();
        const currentUrl = await this.page.url();
        return currentUrl;
    }
}