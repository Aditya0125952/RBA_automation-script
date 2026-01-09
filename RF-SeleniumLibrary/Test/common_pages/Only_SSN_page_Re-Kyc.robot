*** Settings ***
Library    SeleniumLibrary
*** Keywords ***
SSN Re-Kyc Screen
    [Arguments]    ${type}=None
    Wait Until Element Is Visible    ssn   30
    Wait Until Element Is Enabled    ssn    30
    IF    '${type}' == 'None'
        Input Text    ssn    ${application['ssn']}
    ELSE
        Input Text    ssn    ${co_app_dup['ssn']}
    END
    #Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button    10
    #Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button
    Wait Until Element Is Not Visible    ssn    1240