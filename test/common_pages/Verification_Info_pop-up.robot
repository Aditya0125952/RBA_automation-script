*** Settings ***
Library    SeleniumLibrary
*** Keywords ***
verification info pop-up
    ${is_CoApp}=    Run Keyword And Return Status    Should Contain    ${TEST TAGS}    Co-App
    ${creating_new_Url}=         Get Location
    ${match}=    Evaluate    __import__('re').findall(r'[a-z0-9\-]{24,36}', '''${creating_new_Url}''')
    Log To Console    ${match}
    Set Global Variable    ${APP_ID}    ${match[-2]}
    Set Global Variable    ${Location_ID}    ${match[-3]}
    Set Global Variable    ${Merchant_ID}    ${match[0]}
    IF    ${is_CoApp}
        Wait Until Element Is Visible    xpath://*[@id="send-application-modal___BV_modal_body_"]/div/div[8]/div[2]/div/button    20
        Wait Until Element Is Enabled    xpath://*[@id="send-application-modal___BV_modal_body_"]/div/div[8]/div[2]/div/button    120
        Click Button       xpath://*[@id="send-application-modal___BV_modal_body_"]/div/div[8]/div[2]/div/button
    ELSE
        Wait Until Element Is Visible    xpath://*[@id="send-application-modal___BV_modal_body_"]/div/div[7]/div[2]/div/button   20
        Wait Until Element Is Enabled    xpath://*[@id="send-application-modal___BV_modal_body_"]/div/div[7]/div[2]/div/button   180
        Click Element    xpath://*[@id="send-application-modal___BV_modal_body_"]/div/div[7]/div[2]/div/button
    END
    Wait Until Page Contains    Application Sent Successfully!    15