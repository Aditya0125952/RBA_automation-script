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
        await allInputs.nth(0).fill('11765 West Avenue');
        await allInputs.nth(2).fill('San Antonio');
        if(lenderName == "GICU"){
            await allInputs.nth(3).fill('Iowa');
            await allInputs.nth(3).press('Enter');
            await allInputs.nth(4).fill('50014');
        }else{
            await allInputs.nth(3).fill('texas');
            await allInputs.nth(3).press('Enter');
            await allInputs.nth(4).fill('78216');
        }
        await allInputs.nth(5).fill('ana');
        await allInputs.nth(6).fill('villar');
        await allInputs.nth(7).fill('aditya.chelluru@finmkt.io');
        await allInputs.nth(8).fill('9387498374');
        if(CoApp){
            await allInputs.nth(9).waitFor({state: 'visible'});
            await allInputs.nth(9).fill('Morghan');
            await allInputs.nth(10).fill('Blake');
            await allInputs.nth(11).fill('aditya.chelluru+12@finmkt.io');
            await allInputs.nth(12).fill('8978134367');
        }
        await this.page.getByLabel('NO').check();
        await this.page.keyboard.press('Enter');
        await this.page.getByRole('button', {name:'Send Application'}).click();
        const currentUrl = await this.page.url();
        return currentUrl;
    }
}