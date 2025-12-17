import { BasePage } from "./BasePage.page";
import { Locator } from "@playwright/test";

export class BasicInformationPage extends BasePage{

async BasicInformationPage(){
    
    await this.page.waitForLoadState('networkidle');
    const allFormInputs = this.page.locator('input');
    const currenturl = await this.page.url();
    const parse = new URL(currenturl);
    const type = parse.searchParams.get("type");
    if(type != "CO_APPLICANT"){
        await allFormInputs.nth(4).fill('07/01/1981');
        await this.page.keyboard.press('Enter');
        await allFormInputs.nth(10).fill('yes');
        await this.page.keyboard.press('Enter');
        await allFormInputs.nth(11).fill('yes');
        await this.page.keyboard.press('Enter');
        await this.page.locator(`#check`).check();
    }else{
        await allFormInputs.nth(4).fill('07/01/1986');
        await this.page.keyboard.press('Enter');
        await allFormInputs.nth(10).fill('yes');
        await this.page.keyboard.press('Enter');
        await allFormInputs.nth(11).fill('yes');
        await this.page.keyboard.press('Enter');
        await allFormInputs.nth(13).fill('17254 Timberlake Court');
        await allFormInputs.nth(15).fill('Boonville');
        await this.page.waitForTimeout(500);
        await allFormInputs.nth(16).fill('Missouri');
        await allFormInputs.nth(16).press('Enter');
        await allFormInputs.nth(17).fill('65233');
    }
    
    const continueBtn = this.page.getByRole('button',{name:'Continue'});
    await continueBtn.waitFor({state : 'visible'});
    while(1){
        const [response] = await Promise.all([
                this.page.waitForResponse('**/process-payload?**'),
                continueBtn.click(),
            ]);
            const data = await response.json();
            console.log("log data : ",data);
            if (data.meta.success && data.meta.code === 200){
                console.log('Basic Details successful');
                break;
            }else{
                await this.page.waitForTimeout(1000);
            }

    }
}

}