import { test, expect, firefox } from '@playwright/test';
// Corrected path for TestGlobalData (assuming 'Interface' folder is in root)
import { TestGlobalData } from '../Interface/statcDataContainer';
//import * as UserPool from '../TestScenario/userpool.json';
//import { ApplicantData } from '../Interface/interface.js';
import { BasePage } from '../page/BasePage.page';
import { LoginPage } from '../page/Login.page';
import { DashBoardPage } from '../page/dashboard.page';
import { MerchantSelectionAndLocationPage } from '../page/MerchantSelection.page'; 
import{ Dc_Plan_Page } from '../page/Dc_Plan.page';
import { ApplicationDetailsPage } from '../page/Application_Details.page';
import { ApplicantSelectionPage} from '../page/ApplicantSelection.page';
import { ApplicationAuthorizationPage } from '../page/Application_Authorization.page';
import { Credit_Freeze_Page } from '../page/Credit_Freeze.page';
import { Prove_Details_Page } from '../page/Prove_Details.page';
import { BasicInformationPage } from '../page/Basic-Info.page';
import { PersonalInformationPage } from '../page/personal-Info.page';
import { KBAPage } from '../page/KBA.page';
import { OfferPage} from '../page/Offer.page';
import * as dotenv from 'dotenv';
import { setupTestEnvironment } from '../utils/testSetUp.js'; 
import { TestCaseControl } from '../Interface/TestInterface.js'; // Assuming this is your scenario interface
dotenv.config();
import TestScenario from '../TestScenario/test.json';
import { AddressRekyc } from '../page/Address_Rekyc.page';
import fs from 'fs';


test('Login Test - Using ENV Variables', async ({ page }) => {
const scenarioConfig = TestScenario[0];
const { flowControl, lenderSelection, lender } = setupTestEnvironment(scenarioConfig);
new BasePage(page);
test.setTimeout(160000); 
const loginpage = new LoginPage();
const merchantselectionpage = new MerchantSelectionAndLocationPage();
const dashboardpage = new DashBoardPage();
const dcplanpage = new Dc_Plan_Page();
const applicantselectionpage = new ApplicantSelectionPage();
const applicationdetailspage = new ApplicationDetailsPage();
const applicationauthorizationpage = new ApplicationAuthorizationPage();
const creditfreezepage = new Credit_Freeze_Page();
const provedetailspage = new Prove_Details_Page();
const BasicInfoPage = new BasicInformationPage();
const Personal_Info = new PersonalInformationPage();
const OnlyAddressRekyc = new AddressRekyc();
const KbaPage=new KBAPage();
const Offerpage = new OfferPage();

// 5. Test Flow (METHOD CALLS ARE UNTOUCHED)
await loginpage.loadingMerchantPortal('aditya.chelluru+12@finmkt.io','Qa@12345');
await merchantselectionpage.MerchantAndLocationSelection(lenderSelection.merchant , "abcd");
await dashboardpage.SendingAppilication();
await dcplanpage.Dc_Plan_Selection(lenderSelection.dcPlan, lenderSelection.requested_amount, lenderSelection.deposite_amount);
await applicantselectionpage.Applicant_Selection_Page(flowControl.hasCoApplicant);

// Application Details Page will now read applicant data from TestGlobalData internally
const url = await applicationdetailspage.Application_Details_Page(flowControl.hasCoApplicant,lender.name);

await applicationauthorizationpage.Application_Authorization(url);
await creditfreezepage.Credit_Freeze_Details();
await provedetailspage.Prove_Details();
await BasicInfoPage.BasicInformationPage();

// Personal Info Page needs to be updated similarly to Application Details Page
// to pull data from TestGlobalData.applicantData internally.
await Personal_Info.Personal_Info(); 

if(lender.name == "GICU" || lender.name == "PCU"){
    await OnlyAddressRekyc.AddressRekycScreev();
}
await KbaPage.KBApage(flowControl.hasCoApplicant);

if(flowControl.hasCoApplicant){
    await applicationauthorizationpage.Application_Authorization(url,flowControl.hasCoApplicant);
    await creditfreezepage.Credit_Freeze_Details();
    await provedetailspage.Prove_Details();
    await BasicInfoPage.BasicInformationPage();
    await Personal_Info.Personal_Info();
    await KbaPage.KBApage();
}
await Offerpage.waitForOffers(160000,lender.name);
await Offerpage.continueToTilaAndSign();
});
