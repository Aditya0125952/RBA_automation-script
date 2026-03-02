import { Locator, Page, expect } from "@playwright/test";
import { TestGlobalData } from '../Interface/statcDataContainer';
import { BasePage } from "./BasePage.page";

export class LoginPage extends BasePage {
    readonly usernameInput: Locator;
    readonly passwordInput: Locator;
    readonly loginButton: Locator; // Add this

    constructor() {
        super();
        this.usernameInput = this.page.getByPlaceholder('Username');
        this.passwordInput = this.page.getByPlaceholder('Password');
        // Define it here using the role/name you previously had in the selection page
        this.loginButton = this.page.getByRole("button", { name: "Submit" });
    }

    async loadingMerchantPortal(Username: string, Password: string) {
        const instance = TestGlobalData.testControl.instance;
        await this.page.goto(`https://rba${instance.rba}-${instance.server}.mktplacegateway.com/m/login`, {
            waitUntil: 'networkidle',
            timeout: 50000
        });
        
        await this.usernameInput.fill(Username);
        await this.passwordInput.fill(Password);
        
        // NEW: Click submit here so the login is finalized in this POM
        await this.loginButton.click(); 
        console.log("Login submitted, current URL:", await this.page.url());
    }
}