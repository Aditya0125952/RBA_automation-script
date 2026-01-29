*** Settings ***
Library    SeleniumLibrary
*** Keywords ***
Credit freeze page
    Wait Until Element Is Not Visible    css:div.position-absolute.bg-white.rounded-lg    10
    Wait Until Page Contains    Credit Access Reminder    20
    Wait Until Element Is Enabled    xpath:/html/body/div/div[2]/div[1]/div/div/div[2]/div/div[4]/div/button
    Click Element    xpath:/html/body/div/div[2]/div[1]/div/div/div[2]/div/div[4]/div/button