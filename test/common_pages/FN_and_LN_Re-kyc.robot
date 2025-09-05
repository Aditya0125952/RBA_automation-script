*** Settings ***
Library    SeleniumLibrary
*** Keywords ***
LN and FN Re-kyc Screen
    Wait Until Element Is Visible    legal-first-name    30
    Wait Until Element Is Enabled    legal-first-name    30
    Input Text    legal-first-name    anaa
    Wait Until Element Is Visible    legal-last-name    30
    Wait Until Element Is Enabled    legal-last-name    30
    Input Text    legal-last-name    villarr
    Wait Until Element Is Not Visible    legal-first-name    120
