import { Locator, Page, expect } from "@playwright/test";
import { BasePage } from "./BasePage.page";

export class LoginPage extends BasePage {

    //locators
    readonly usernameInput : Locator;
    readonly passwordInput : Locator;
    constructor() {
        super();
        this.usernameInput = this.page.getByPlaceholder('Username');
        this.passwordInput = this.page.getByPlaceholder('Password');
        
    }
    

    
    async loadingMerchantPortal(Username: string, Password: string) {
        
            await this.page.goto('https://rba6-test.mktplacegateway.com/m/login', {
                waitUntil: 'networkidle',
                timeout: 30000 // 30 seconds timeout
            });
            
            await this.usernameInput.fill(Username);
            await this.passwordInput.fill(Password);

    }
           
}