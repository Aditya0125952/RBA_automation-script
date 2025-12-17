*** Settings ***
Library    SeleniumLibrary
*** Keywords ***
Merchant Selection Page
    [Arguments]    ${merchant}=None
    Wait Until Element Is Visible    merchant-selection-modal___BV_modal_title_    60
    Wait Until Element Is Enabled    merchant-selection-modal___BV_modal_title_    60
    IF    '${merchant}' == 'None'
        Select From List By Label        xpath://*[@id="merchant-selection-modal___BV_modal_body_"]/div/div/select    ${LENDER_DATA['Merchant']}
    ELSE
        Select From List By Label        xpath://*[@id="merchant-selection-modal___BV_modal_body_"]/div/div/select    ${merchant}
    END