import { Page } from "@playwright/test";
import { BasePage } from "../../BasePage.page";
import { TilaStrategy } from "../Core/TilaStrategy";

export class GICU_TILA extends BasePage implements TilaStrategy {
    constructor(page:Page){
        super(page);
    }
    async sign(): Promise<void> {
        //scrolling related
        const pdfFrame = this.page.frameLocator('#webviewer-1');
        await pdfFrame.locator('canvas').first().waitFor({
            state: 'visible',
            timeout: 30000
        });
        await pdfFrame.evaluate(async () => {
            const scrollingElement =
                document.scrollingElement || document.documentElement;

            if (!scrollingElement) return;

            for (let i = 0; i < 15; i++) {
                scrollingElement.scrollTop = scrollingElement.scrollHeight;
                await new Promise(r => setTimeout(r, 300));
            }
        });
        //signature related
        await this.page.getByRole('button', { name: 'Click to Sign' }).waitFor({ state: 'visible' });
        await this.page.getByRole('button', { name: 'Click to Sign' }).click();
        await this.page.locator('[class*="signature"]').nth(0).click();
        //check boxs related
        const checkboxes = this.page.locator('input[type="checkbox"]');
        await checkboxes.nth(0).check();
        await checkboxes.nth(1).check();
        //continue button
        await this.page.getByRole('button', { name: 'Continue' }).waitFor({ state: 'enabled' });
        await this.page.getByRole('button', { name: 'Continue' }).click();

    }

}