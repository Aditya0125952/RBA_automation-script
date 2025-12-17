import { Page,Locator } from "@playwright/test";
import { BasePage } from "./BasePage.page";

export class DashBoardPage extends BasePage{

    async SendingAppilication(){
        const [NewPage] = await Promise.all([
            this.page.waitForEvent('popup'),
            await this.page.getByRole('button',{name: 'Send Application'}).click()
        ]);
        await NewPage.waitForLoadState('domcontentloaded');
        //await this.page.getByRole('button',{name: 'Send Application'}).click();
        const URL = NewPage.url();
        await NewPage.close();
        await this.page.goto(URL);
    }

}
