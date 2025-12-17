*** Settings ***
Library    SeleniumLibrary
*** Keywords ***
selecting the merchant location
    [Arguments]    ${location}=None
    Wait Until Element Is Visible    location-selection-modal___BV_modal_content_    30
    Wait Until Element Is Enabled    location-selection-modal___BV_modal_content_    30
    IF    '${location}'=='None'
        Select From List By Label        xpath://*[@id="location-selection-modal___BV_modal_body_"]/div/div/select    ${LENDER_DATA['Location']}
    ELSE
        Select From List By Label        xpath://*[@id="location-selection-modal___BV_modal_body_"]/div/div/select    ${location}
    END