*** Settings ***
Library    SeleniumLibrary
Library    Collections
*** Keywords ***
Type of Application page
    ${is_CoApp}=    Run Keyword And Return Status    Should Contain    ${TEST TAGS}    Co-App
    Wait Until Element Is Not Visible    css:div.position-absolute.bg-white.rounded-lg    20
    IF    ${is_CoApp}
        Wait Until Element Is Enabled    xpath://input[@value='2']    20
        Click Button    xpath://input[@value='2']
    ELSE
        Wait Until Element Is Enabled    xpath://input[@value='1']    20
        Click Button    xpath://input[@value='1']
    END
    Click Button    xpath://button[@type='button']
