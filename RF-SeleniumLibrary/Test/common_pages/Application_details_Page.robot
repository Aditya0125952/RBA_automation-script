*** Settings ***
Library    SeleniumLibrary
Library    JSONLibrary
*** Keywords ***
Application Details Page
    ${is_CoApp}=    Run Keyword And Return Status    Should Contain    ${TEST TAGS}    Co-App
    Wait Until Element Is Not Visible    css:div.position-absolute.bg-white.rounded-lg    20
    Wait Until Element Is Enabled    street-address-1
    Input Text    street-address-1    ${application["street_add"]}
    Input Text    city    ${application["city"]}
    Select From List By Label        street-address-state    ${application["state"]}
    Input Text    zipCode    ${application["zipcode"]}
    Input Text    legal-first-name    ${application["FirstName"]}
    Input Text    legal-last-name    ${application["LastName"]}
    Input Text    email     ${application["email"]}
    Input Text    mobile-number    ${application["mobileNumber"]}
    Wait Until Element Is Not Visible    css=.position-absolute.bg-white.rounded-lg    timeout=30
    IF    ${is_CoApp}
        Wait Until Element Is Visible    coapp-legal-first-name    10
        Wait Until Element Is Enabled    coapp-legal-first-name    10
        Input Text    coapp-legal-first-name    ${co_app_dup['FirstName']}
        Wait Until Element Is Enabled    coapp-legal-last-name    10
        Input Text    coapp-legal-last-name    ${co_app_dup['LastName']}
        Wait Until Element Is Enabled    xpath:(//input[@id="email"])[2]    10
        Input Text    xpath:(//input[@id="email"])[2]    ${co_app_dup['email']}
        Wait Until Element Is Enabled    xpath:(//input[@id="mobile-number"])[2]   8
        Input Text    xpath:(//input[@id="mobile-number"])[2]    ${co_app_dup['mobileNumber']}
    END
    Wait Until Element Is Visible    no    10
    Wait Until Element Is Enabled    yes    10
    Click Element    yes
    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/span/form/div[3]/div/div/div/div/div[2]/div/button    10
    Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/span/form/div[3]/div/div/div/div/div[2]/div/button