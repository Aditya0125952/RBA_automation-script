*** Settings ***
Library    SeleniumLibrary
*** Keywords ***
FN and DOB Re-Kyc Screen
    Wait Until Element Is Visible    legal-first-name    30
    Wait Until Element Is Enabled    legal-first-name    30
    Input Text    legal-first-name    ana
    Wait Until Element Is Visible    xpath=//input[@name='dob']    10
    Wait Until Element Is Enabled    xpath=//input[@name='dob']    10
    Input Text    xpath=//input[@name='dob']    01/01/1990
    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button    10
    Wait Until Element Is Not Visible    legal-first-name    120
    