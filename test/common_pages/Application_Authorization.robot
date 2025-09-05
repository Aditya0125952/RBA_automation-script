*** Settings ***
Library    SeleniumLibrary
*** Keywords ***
Application Authorization Page
    Wait Until Element Is Not Visible    css:div.position-absolute.bg-white.rounded-lg    120
    Wait Until Element Is Enabled    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div[5]/div/div/button/div    120
    Click Element    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div[5]/div/div/button/div