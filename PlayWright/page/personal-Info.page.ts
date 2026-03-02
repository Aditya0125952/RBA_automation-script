import { TestGlobalData } from "../Interface/statcDataContainer";
import { BasePage } from "./BasePage.page";
import { ApplicantData } from "../Interface/interface.js";
import { url } from "inspector";

export class PersonalInformationPage extends BasePage{
    async Personal_Info(){

        const applicant : ApplicantData = TestGlobalData.applicantData;
        const coApplicant : ApplicantData | null = TestGlobalData.coApplicantData;  

        const continuebutton = this.page.getByRole('button',{name:'Continue'});
        await continuebutton.waitFor({state: 'visible'});
        let allFormInputs = this.page.locator('input');
        const currenturl = await this.page.url();
        const parse = new URL(currenturl);
        const type = parse.searchParams.get("type");
        if(type != "CO_APPLICANT"){
            await this.page.locator('#annualGrossIncome').fill(applicant.annual_income);
            await this.page.locator('#annualHouseholdIncome').fill(applicant.household_income);
            await allFormInputs.nth(2).fill(applicant.employment_status);
            await this.page.keyboard.press('Enter');
            await allFormInputs.nth(3).fill(applicant.citizenship_status);
            await this.page.keyboard.press('Enter');
            allFormInputs = this.page.locator('input');
            const updatedCount = await allFormInputs.count();
            if(updatedCount == 8){
                await this.page.locator('#occupation').fill(applicant.occupation);
                await this.page.locator('#currentEmployer').fill(applicant.employer_name);
            }
            await this.page.locator('#monthlyHousing').fill(applicant.monthly_mortgage_amount);
            await this.page.waitForTimeout(3000);
            await this.page.locator('#ssn').fill(applicant.ssn);
        }else{
            await this.page.locator('#annualGrossIncome').fill(coApplicant.annual_income);
            await this.page.locator('#annualHouseholdIncome').fill(coApplicant.household_income);
            await allFormInputs.nth(2).fill(coApplicant.employment_status);
            await this.page.keyboard.press('Enter');
            await allFormInputs.nth(3).fill(coApplicant.citizenship_status);
            await this.page.keyboard.press('Enter');
            allFormInputs = this.page.locator('input');
            const updatedCount = await allFormInputs.count();
            if(updatedCount == 8){
                await this.page.locator('#occupation').fill(coApplicant.occupation);
                await this.page.locator('#currentEmployer').fill(coApplicant.employer_name);
            }
            await this.page.locator('#monthlyHousing').fill(coApplicant.monthly_mortgage_amount);
            await this.page.waitForTimeout(3000);
            await this.page.locator('#ssn').fill(coApplicant.ssn);
        }
           
    }
}