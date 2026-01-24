import { Page, expect } from "@playwright/test"; // Import expect
import { BasePage } from "../../BasePage.page";
import { TilaStrategy } from "../Core/TilaStrategy";

export class PCU_TILA extends BasePage implements TilaStrategy {
    constructor(page: Page) {
        super(page);
    }

    async sign(): Promise<void> {
        console.log('✍️ [TILA] PCU_TILA.sign() invoked');
        
        // 2️⃣ Wait for TILA PDF viewer to load
        await this.page.waitForSelector("#webviewer-1", {
        timeout: 60000
        });

        const frame = this.page.frameLocator('#webviewer-1');
        const pdfCanvas = frame.locator('canvas').first();

        // --- SCROLLING LOGIC ---
        try {
            await pdfCanvas.waitFor({ state: 'visible', timeout: 60000 });
            await this.page.waitForTimeout(2000); 
        } catch (e) {
            console.error('❌ Timeout waiting for PDF canvas. Viewer might have failed.');
            throw e;
        }

        const scrollContainerLocator = frame.locator('#viewerContainer, .pageWidgetContainer, body').first();
        let isTrulyAtBottom = false;
        let attempts = 0;
        const maxTotalAttempts = 100;
        let noMovementCounter = 0; 
        const maxNoMovementTolerance = 5; 

        await pdfCanvas.hover({ force: true });

        while (!isTrulyAtBottom && attempts < maxTotalAttempts) {
            attempts++;
            const scrollTopBefore = await scrollContainerLocator.evaluate((el) => el.scrollTop);
            await this.page.mouse.wheel(0, 800);
            await this.page.waitForTimeout(500);
            const scrollTopAfter = await scrollContainerLocator.evaluate((el) => el.scrollTop);

            if (Math.abs(scrollTopAfter - scrollTopBefore) < 2) {
                noMovementCounter++;
                if (noMovementCounter >= maxNoMovementTolerance) {
                    isTrulyAtBottom = true;
                }
                await this.page.waitForTimeout(500);
            } else {
                noMovementCounter = 0;
            }
        }
        await this.page.waitForTimeout(2000);

        // --- SIGNATURE LOGIC ---
        const clickToSignButton = this.page.getByRole('button', { name: /Click to Sign/i });
        await clickToSignButton.waitFor({ state: 'visible', timeout: 30000 });
        await clickToSignButton.click();
        const signaturePad = this.page.locator('.signature-pad');
        await signaturePad.waitFor({ state: 'visible', timeout: 30000 });
        const signatureBlocks = signaturePad.locator('.signature-pad__sig-block');
        const count = await signatureBlocks.count();
        console.log(`Found ${count} signature options.`);

        if (count > 0) {
            const randomIndex = Math.floor(Math.random() * count);
            const randomSignature = signatureBlocks.nth(randomIndex);
            await randomSignature.click();
            await this.page.waitForTimeout(1000);
        } else {
            console.error('❌ No signature options found in the signature pad.');
            throw new Error('Signature selection failed');
        }

        //Checking the checkboxes
        const sharedIdCheckboxes = this.page.locator('#check');
        await sharedIdCheckboxes.nth(0).click();
        await sharedIdCheckboxes.nth(1).click();
        // clicking continues for the disclosure page
        await this.page.getByRole('button', { name: 'Continue' }).click();
       //credit disclouser page
         await this.page.getByRole('button', { name: 'Continue' }).click();
        //membership page
        await this.page.getByText('Almost Done!').waitFor({ state: 'visible', timeout: 30000 });
        const typeless= this.page.locator('input[type=""]');
        await typeless.nth(0).fill('9999999999');
        await typeless.nth(1).click();
        await typeless.nth(1).press('Backspace');
        await typeless.nth(1).fill('1');
        await typeless.nth(2).click();
        await typeless.nth(2).press('Backspace');
        await typeless.nth(2).fill('1');
        await typeless.nth(4).fill('Mother');
        await typeless.nth(6).click();
        await typeless.nth(6).press('Backspace');
        await typeless.nth(6).fill('1');
        await typeless.nth(7).click();
        await typeless.nth(7).press('Backspace');
        await typeless.nth(7).fill('1');
        await typeless.nth(9).fill('7382637826');
        const dropdown= this.page.locator('input[type="search"]');
        await dropdown.nth(2).click();
        await this.page.getByText('Cell').click();
        await dropdown.nth(3).click();
        await this.page.getByText('Morning').click();
        await this.page.getByRole('button', { name: 'Click to Sign' }).click();
        await this.page.locator('#check').click();
        await this.page.getByRole('button', { name: 'Continue' }).click();
    
    }
}