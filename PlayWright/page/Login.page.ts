import { Locator, Page, expect } from "@playwright/test";
import { TestGlobalData } from '../Interface/statcDataContainer';
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
        const instance = TestGlobalData.testControl.instance;
        
            await this.page.goto(`https://rba${instance.rba}-${instance.environment}.mktplacegateway.com/m/login`, {
                waitUntil: 'networkidle',
                timeout: 50000 // 30 seconds timeout
            });
            
            await this.usernameInput.fill(Username);
            await this.passwordInput.fill(Password);
            console.log("Login Url", await this.page.url());

    }
           
}