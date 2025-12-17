import { BasePage } from "./BasePage.page";

export class PersonalInformationPage extends BasePage{
    async Personal_Info(){
        const continuebutton = this.page.getByRole('button',{name:'Continue'});
        await continuebutton.waitFor({state: 'visible'});
        let allFormInputs = this.page.locator('input');
        const currenturl = await this.page.url();
        const parse = new URL(currenturl);
        const type = parse.searchParams.get("type");
        if(type != "CO_APPLICANT"){
            await this.page.locator('#annualGrossIncome').fill('100000');
            await this.page.locator('#annualHouseholdIncome').fill('200000');
            await allFormInputs.nth(2).fill('emp');
            await this.page.keyboard.press('Enter');
            await allFormInputs.nth(3).fill('us');
            await this.page.keyboard.press('Enter');
            allFormInputs = this.page.locator('input');
            const updatedCount = await allFormInputs.count();
            if(updatedCount == 8){
                await this.page.locator('#occupation').fill('Testing');
                await this.page.locator('#currentEmployer').fill('FinMkt');
            }
            await this.page.locator('#monthlyHousing').fill('500');
            await this.page.waitForTimeout(3000);
            await this.page.locator('#ssn').fill('666308630');
        }else{
            await this.page.locator('#annualGrossIncome').fill('120000');
            await this.page.locator('#annualHouseholdIncome').fill('150000');
            await allFormInputs.nth(2).fill('emp');
            await this.page.keyboard.press('Enter');
            await allFormInputs.nth(3).fill('us');
            await this.page.keyboard.press('Enter');
            allFormInputs = this.page.locator('input');
            const updatedCount = await allFormInputs.count();
            if(updatedCount == 8){
                await this.page.locator('#occupation').fill('Testing');
                await this.page.locator('#currentEmployer').fill('FinMkt');
            }
            await this.page.locator('#monthlyHousing').fill('500');
            await this.page.waitForTimeout(3000);
            await this.page.locator('#ssn').fill('666971260');
        }

        
           
    }
}