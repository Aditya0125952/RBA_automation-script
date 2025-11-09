*** Settings ***
Library    SeleniumLibrary
*** Keywords ***
DOB Re-Kyc Screen
    [Arguments]    ${type}=None
    Wait Until Element Is Visible    xpath=//input[@name='dob']    10
    Wait Until Element Is Enabled    xpath=//input[@name='dob']    10
    IF    '${type}'=='None'
        Input Text    xpath=//input[@name='dob']    ${application['dob']}
    ELSE
        Input Text    xpath=//input[@name='dob']    ${co_app_dup['dob']}
    END
    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button    10
    Wait Until Element Is Not Visible    xpath=//input[@name='dob']     120
    #Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button