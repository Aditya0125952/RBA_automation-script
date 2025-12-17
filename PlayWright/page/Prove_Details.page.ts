import { log } from "console";
import { BasePage } from "./BasePage.page";


export class Prove_Details_Page extends BasePage {

    async Prove_Details(){
        const continuBtn = this.page.getByRole('button',{name : 'Continue'});
        await continuBtn.waitFor({state : 'visible'});
        const currenturl = await this.page.url();
        const parse = new URL(currenturl);
        const type = parse.searchParams.get("type");
        const inputFields = this.page.locator('input');
        if(type != "CO_APPLICANT"){
            await inputFields.nth(0).fill('666308630');
            await inputFields.nth(1).fill('8880297482');
        }else{
            await inputFields.nth(0).fill('666971260');
            await inputFields.nth(1).fill('8880297412');
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