*** Settings ***
Library    SeleniumLibrary
*** Keywords ***
First Name Re-Kyc Screen
    [Arguments]    ${type}=None
    Wait Until Element Is Visible    legal-first-name    30
    Wait Until Element Is Enabled    legal-first-name    30
    IF    '${type}' == 'None'
        Input Text    legal-first-name    ${application['FirstName']}
    ELSE
        Input Text    legal-first-name    ${co_app_dup['FirstName']}
    END
    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button    10
    #Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button
    Wait Until Element Is Not Visible    legal-first-name    120