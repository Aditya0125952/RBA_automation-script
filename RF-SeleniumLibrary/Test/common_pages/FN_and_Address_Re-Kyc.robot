*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
First Name and Address Re-Kyc Screen
    Wait Until Element Is Visible    legal-first-name    30
    Wait Until Element Is Enabled    legal-first-name    30
    Input Text    legal-first-name    ana
    Wait Until Element Is Visible    address-1
    Wait Until Element Is Enabled    address-1
    Input Text    address-1    ${applicant['street_add']}
    Input Text    city    ${applicant['city']}
    Select From List By Label    KYC__BILLING__ADDRESS__CITY    ${applicant['state']}
    Input Text    zipCode    ${applicant['zipcode']}
    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button    10