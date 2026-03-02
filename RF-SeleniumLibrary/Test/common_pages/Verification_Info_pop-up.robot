*** Settings ***
Library    SeleniumLibrary
*** Keywords ***
verification info pop-up
    ${is_CoApp}=         Run Keyword And Return Status    Should Contain    ${TEST TAGS}    Co-App
    ${current_Url}=      Get Location
    
    # Use Regex to target specific keys in the URL
    ${Merchant_ID}=      Evaluate    __import__('re').search(r'm=([a-z0-9\-]+)', '''${current_Url}''').group(1)
    ${Location_ID}=      Evaluate    __import__('re').search(r'locationId=([a-z0-9\-]+)', '''${current_Url}''').group(1)
    ${APP_ID}=           Evaluate    __import__('re').search(r'appId=([a-z0-9\-]+)', '''${current_Url}''').group(1)

    # Set them as global variables for use in other tests
    Set Global Variable    ${APP_ID}
    Set Global Variable    ${Location_ID}
    Set Global Variable    ${Merchant_ID}

    Log To Console    Merchant: ${Merchant_ID}, Location: ${Location_ID}, App: ${APP_ID}
    IF    ${is_CoApp}
        Wait Until Element Is Visible    xpath://*[@id="send-application-modal___BV_modal_body_"]/div/div[8]/div[2]/div/button    20
        Wait Until Element Is Enabled    xpath://*[@id="send-application-modal___BV_modal_body_"]/div/div[8]/div[2]/div/button    120
        Click Button       xpath://*[@id="send-application-modal___BV_modal_body_"]/div/div[8]/div[2]/div/button
    ELSE
        Wait Until Element Is Visible    xpath://*[@id="send-application-modal___BV_modal_body_"]/div/div[7]/div[2]/div/button   20
        Wait Until Element Is Enabled    xpath://*[@id="send-application-modal___BV_modal_body_"]/div/div[7]/div[2]/div/button   180
        Scroll Element Into View    xpath://*[@id="send-application-modal___BV_modal_body_"]/div/div[7]/div[2]/div/button
        Click Element    xpath://*[@id="send-application-modal___BV_modal_body_"]/div/div[7]/div[2]/div/button
    END
    Wait Until Page Contains    Application Sent Successfully!    15