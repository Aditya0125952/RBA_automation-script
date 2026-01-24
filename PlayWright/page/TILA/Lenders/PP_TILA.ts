import { Page } from "@playwright/test";
import { BasePage } from "../../BasePage.page";
import { TilaStrategy } from "../Core/TilaStrategy";

export class PP_TILA extends BasePage implements TilaStrategy {

    constructor(page: Page) {
        super(page);
    }

    async sign(): Promise<void> {
        console.log('✍️ PP_TILA.sign() invoked');

        // 1. Click the initial "Click to Sign" button on the main page
        //
        await this.page.getByRole('button', { name: /Click to Sign/i }).click();

        // --- DEFINE INITIAL IFRAME CONTEXT ---
        //
        let frame = this.page.frameLocator('.x-hellosign-embedded__iframe');

        // 2. Handle initial modals inside the iframe
        // Wait for and click the "OK" button
        //
        const okButton = frame.getByRole('button', { name: 'OK', exact: true });
        await okButton.waitFor({ state: 'visible', timeout: 30000 });
        await okButton.click();
        console.log('✅ "OK" button inside iframe clicked.');

        // Wait for and click the "Get started" button
        //
        const getStartedBtn = frame.getByRole('button', { name: /Get started/i });
        await getStartedBtn.waitFor({ state: 'visible' });
        await getStartedBtn.click();
        console.log('✅ "Get started" button inside iframe clicked.');


        // --- STEP 3: Locate and Click the "Click to Sign" field in the document ---
        console.log('⏳ Waiting for document to load and signature field to appear...');
        //
        const signatureField = frame.getByText('Click to Sign').first();

        await signatureField.waitFor({ state: 'visible', timeout: 60000 });
        // Small wait to ensure interactivity before the click that causes navigation
        await this.page.waitForTimeout(1000);
        await signatureField.click();
        console.log('✅ "Click to Sign" field in document clicked.');


        // --- CRITICAL FIX: RE-ESTABLISH FRAME & WAIT FOR MODAL ---
        console.log('🔄 Re-acquiring frame context after navigation...');
        // Define the frame locator again because the iframe reloaded.
        //
        frame = this.page.frameLocator('.x-hellosign-embedded__iframe');

        console.log('⏳ Waiting for "Add your signature" modal header to appear...');
        // We wait for the modal header text first. This confirms the frame is loaded
        // and the modal structure is present before we look for the canvas.
        //
        const modalHeader = frame.getByText('Add your signature', { exact: true });
        await modalHeader.waitFor({ state: 'visible', timeout: 60000 });
        console.log('✅ Modal header detected. Frame is ready.');
        console.log('Canvas count:', await frame.locator('canvas').count());



        // --- STEP 4: Draw on the Signature Canvas ---
console.log('⏳ Waiting for signature canvas to be ready...');

const signatureCanvas = frame.locator('#signature-modal-draw__canvas');

// Ensure canvas exists and is visible
await signatureCanvas.waitFor({
  state: 'visible',
  timeout: 60000,
});

// Sometimes boundingBox is null on first attempt due to re-render
let box = null;
for (let i = 0; i < 5; i++) {
  box = await signatureCanvas.boundingBox();
  if (box) break;
  await this.page.waitForTimeout(500);
}

if (!box) {
  throw new Error('❌ Signature canvas bounding box not found');
}

console.log('✍️ Drawing signature on canvas...');

const startX = box.x + box.width * 0.15;
const startY = box.y + box.height * 0.5;

// Use page.mouse (NOT frame.mouse)
await this.page.mouse.move(startX, startY);
await this.page.mouse.down();

// Draw a realistic signature curve
await this.page.mouse.move(startX + 60, startY - 15, { steps: 10 });
await this.page.mouse.move(startX + 120, startY + 10, { steps: 10 });
await this.page.mouse.move(startX + 180, startY - 5, { steps: 10 });

await this.page.mouse.up();

console.log('✅ Signature drawn on canvas');

// Allow HelloSign to enable the Insert button
await this.page.waitForTimeout(1000);


        // --- STEP 5: Click "Insert everywhere" ---
        //
        const insertButton = frame.getByRole('button', { name: /Insert everywhere/i });
        // Wait for button to become enabled after drawing
        await insertButton.waitFor({ state: 'visible', timeout: 30000 });
        await insertButton.click();
        console.log('✅ "Insert everywhere" button clicked.');
        const ctnbutton= frame.getByRole('button', { name: /Continue/i });
        await ctnbutton.waitFor({ state: 'visible', timeout: 30000 });
        await ctnbutton.click();
        console.log('✅ "Continue" button clicked.');
        const agreebutton= frame.getByRole('button', { name: /i agree/i });
        await agreebutton.waitFor({ state: 'visible', timeout: 30000 });
        await agreebutton.click();
        console.log('✅ "agree" button clicked.');
        const clsbutton= frame.getByRole('button', { name: /close/i });
        await clsbutton.waitFor({ state: 'visible', timeout: 30000 });
        await clsbutton.click();
        console.log('✅ "close" button clicked.');
        // Final wait to allow submission to complete
        // --- STEP 6: Click Continue on main page with retry handling ---
const continueBtn = this.page.getByRole('button', { name: /^Continue$/i });
const successScreen = this.page.getByText("You're all set!", { exact: false });
const noSignModalTitle = this.page.getByText('No sign selected!', { exact: true });
const okGotItBtn = this.page.getByRole('button', { name: /OK,\s*Got\s*It/i });

const maxRetries = 10;
let attempt = 0;

while (attempt < maxRetries) {
  attempt++;
  console.log(`➡️ Continue attempt ${attempt}`);

  await continueBtn.waitFor({ state: 'visible', timeout: 30000 });
  await continueBtn.click();

  const outcome = await Promise.race([
    successScreen
      .waitFor({ state: 'visible', timeout: 30000 })
      .then(() => 'SUCCESS'),
    noSignModalTitle
      .waitFor({ state: 'visible', timeout: 30000 })
      .then(() => 'NO_SIGN'),
  ]);

  if (outcome === 'SUCCESS') {
    console.log('🎉 Success screen reached');
    break;
  }

  console.log('⚠️ "No sign selected!" popup detected');

  // Handle popup
  await okGotItBtn.waitFor({ state: 'visible', timeout: 10000 });
  await okGotItBtn.click();
  console.log('✅ OK, Got It clicked');

  // Mandatory wait before retry
  await this.page.waitForTimeout(5000);
}

if (attempt === maxRetries) {
  throw new Error(
    `❌ "No sign selected!" popup appeared ${maxRetries} times. Aborting TILA flow.`
  );
}

console.log('✅ TILA process completed for PP lender.');


}
}