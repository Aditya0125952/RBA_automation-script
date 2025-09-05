*** Settings ***
Library    SeleniumLibrary
Library    JSONLibrary
Resource    ../common_pages/Application_details_Page.robot
*** Keywords ***
prove data
    [Arguments]    ${type}=None
    Wait Until Element Is Enabled    ssn    20
    IF    '${type}' == 'None'
        Input Text    ssn    ${application['ssn']}
        Input Text    prove-mobile-number    ${application['mobileNumber']}
    ELSE
        Input Text    ssn    ${co_app_dup['ssn']}
        Input Text    prove-mobile-number    ${co_app_dup['mobileNumber']}
    END
    Sleep    3
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div/div[2]/div/span/form/fieldset/div/div[6]/div/div/button