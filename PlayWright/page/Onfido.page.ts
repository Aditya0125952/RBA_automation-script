import { BasePage } from "./BasePage.page";

export class OnfidoSubmitionPage extends BasePage{
    async function getOnfidoFrame(page) {
  const handle = await page.waitForFunction(() => {
    const frames = Array.from(document.querySelectorAll("iframe"));
    // Only return active iframes (visible + with src)
    return frames.find(f =>
      f.src &&
      f.src.includes("onfido.com") &&
      f.offsetParent !== null
    );
  }, { timeout: 30000 });

  const selector = await handle.evaluate(el => {
    el.setAttribute("data-onfido", "active");
    return 'iframe[data-onfido="active"]';
  });

  return page.frameLocator(selector);
}

async OnfidoSubmitionPage(){
 let frame = await getOnfidoFrame(page);
  await frame.getByRole('button', { name: 'Start verification' }).click();

  // SCREEN 2 — Choose document type
  frame = await getOnfidoFrame(page);
  await frame.getByRole('button', { name: "Driver’s license" }).click();

  // SCREEN 3 — Upload photo
  frame = await getOnfidoFrame(page);
  const fileChooserPromise = page.waitForEvent('filechooser');
  await frame.getByRole('button', { name: "Upload photo" }).click();
  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles('PlayWright\\tests\\front_dl.jpg');

  frame = await getOnfidoFrame(page);
  await frame.getByRole('button', { name: "Upload" }).click();

  frame = await getOnfidoFrame(page);
  const fileChooserPromise2 = page.waitForEvent('filechooser');
  await frame.getByRole('button', { name: "Continue" }).click();
  const fileChooser2 = await fileChooserPromise2;
  await fileChooser2.setFiles('PlayWright\\tests\\front_dl.jpg');

  frame = await getOnfidoFrame(page);
  await frame.getByRole('button', { name: "Upload" }).click();

  await expect(page.getByText('Thank You!')).toBeVisible({timeout: 15000});
  console.log('success!');


}

}