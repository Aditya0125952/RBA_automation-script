import { BasePage } from "./BasePage.page"

export class ApplicationAuthorizationPage extends BasePage{

    async Application_Authorization(url:string,coapp?:Boolean){
        const parsed = new URL(url);
        const appId = parsed.searchParams.get("appId");
        const merchantId = parsed.searchParams.get("m");
        const locationId = parsed.searchParams.get("locationId");
        let finalUrl: string;

        if(coapp){
            const currenturl= await this.page.url();
            const co_parsed=new URL(currenturl);
            const loanId= co_parsed.searchParams.get("loanId");
            finalUrl = 
            `https://rba6-test.mktplacegateway.com/gateway-pos/v2/consent/v1`+
            `?loanId=${loanId}`+
            `&type=CO_APPLICANT`+
            `&m=${merchantId}`+
            `&locationId=${locationId}`;
        }else{
            finalUrl =
            `https://rba6-test.mktplacegateway.com/gateway-pos/v2/consent/v1`+
            `?appId=${appId}`+
            `&type=APPLICANT`+
            `&m=${merchantId}`+
            `&locationId=${locationId}`;
        }

        // open new tab
        const newTab = await this.page.context().newPage();
        await newTab.goto(finalUrl, { waitUntil: "domcontentloaded" });

        // update global page reference
        BasePage.updatePage(newTab);

        // interact in new tab
        await newTab.locator('button:has-text("Agree")').click();

        return newTab;

    }

}