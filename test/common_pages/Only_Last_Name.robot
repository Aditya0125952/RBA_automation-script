*** Settings ***
Library    SeleniumLibrary
*** Keywords ***
Last Name Re-Kyc Screen
    [Arguments]    ${type}=None
    Wait Until Element Is Visible    legal-last-name    30
    Wait Until Element Is Enabled    legal-last-name    30
    IF    '${type}' == 'None'
        Input Text    legal-last-name    ${application['LastName']}
    ELSE
        Input Text    legal-last-name    ${co_app_dup['LastName']}
    END
    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button    10
    #Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button
    Wait Until Element Is Not Visible    legal-last-name    120