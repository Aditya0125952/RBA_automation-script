import { Locator, Page, expect } from "@playwright/test";
import Fuse from "fuse.js";
import { BasePage } from "./BasePage.page";

export class MerchantSelectionAndLocationPage extends BasePage {
    readonly LoginButton: Locator;
    constructor() {
        super();
        this.LoginButton = this.page.getByRole('button', { name: 'Submit' });
    }
    async MerchantAndLocationSelection(Merchant: string, Location?: string) {
        console.log(`Waiting for merchant list API and clicking submit...`);
        const [response] = await Promise.all([
            this.page.waitForResponse('**/api/pos/login/merchants'),
            this.LoginButton.click(),
        ]);

        if (!response.ok()) {
            throw new Error(`API call failed with status: ${response.status()}`);
        }

        const data = await response.json();
        
        // --- DEBUGGING STARTS HERE ---
        // Log the full response to inspect its structure
        console.log("Full Merchant API Response:", JSON.stringify(data, null, 2));

        // Safety check: Verify data.users exists and is an array
        if (!data || !data.users || !Array.isArray(data.users)) {
            console.error("Critical Error: API response is missing the 'users' array.");
            throw new Error("Invalid API response structure for merchant list.");
        }

        if (data.users.length === 0) {
            console.warn("Warning: The merchant list returned from the API is empty.");
        }
        // --- DEBUGGING ENDS HERE ---

        const option = {
            keys: ['merchantName'],
            threshold: 0.3
        }
        
        // Initialize Fuse with the validated users array
        const fuse = new Fuse(data.users, option);
        
        console.log(`Searching for merchant: '${Merchant}'`);
        const result = fuse.search(Merchant);

        // Safety check: Ensure search returned at least one result
        if (result.length === 0) {
            console.error(`Error: No merchant found matching '${Merchant}'.`);
            // Log available merchants to help with debugging
            const availableMerchants = data.users.map((u: any) => u.merchantName).join(", ");
            console.log(`Available merchants were: ${availableMerchants}`);
            throw new Error(`Merchant searched '${Merchant}' not found in the list.`);
        }

        // Now it's safe to access the first result
        const foundmerchant = result[0].item.merchantName;
        console.log('Selected merchant found by fuzzy search: ', foundmerchant);

        // ... rest of your logic for location selection
        const [locationResponse] = await Promise.all([
            this.page.waitForResponse('**/api/pos/merchant/login'),
            this.page.selectOption('select.login-selectdropdown', { label: foundmerchant }),
        ]);
        const locationdata = await locationResponse.json();
        if (locationdata.status != 'success') {
            // Ensure userLocationConfigs exists and has elements before accessing index 0
            if (locationdata.merchantUser?.userLocationConfigs?.length > 0) {
                await this.page.selectOption('select.login-selectdropdown', { label: locationdata.merchantUser.userLocationConfigs[0].locationName });
            } else {
                 console.error("Could not auto-select location: userLocationConfigs is missing or empty.");
            }
        }
    }
}