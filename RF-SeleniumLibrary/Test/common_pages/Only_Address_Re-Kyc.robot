*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Address Re-Kyc screen
    [Arguments]    ${type}=None
    Wait Until Element Is Visible    address-1    20
    Wait Until Element Is Enabled    address-1    20
    IF    '${type}' == 'None'
        Input Text    address-1    ${applicant['street_add']}
        Input Text    city    ${applicant['city']}
        Select From List By Label    KYC__BILLING__ADDRESS__CITY    ${applicant['state']}
        Input Text    zipCode    ${applicant['zipcode']}
    ELSE
        Input Text    address-1    ${co_app_dup['street_add']}
        Input Text    city    ${co_app_dup['city']}
        Select From List By Label    KYC__BILLING__ADDRESS__CITY    ${co_app_dup['state']}
        Input Text    zipCode    ${co_app_dup['zipcode']}
    END
    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button    10
    #Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button
