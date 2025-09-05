*** Settings ***
Library    SeleniumLibrary

*** Variables ***
@{Instance}
...    rba    rba2    rba3    rba4    rba5    rba6
${base_url}    rba

*** Keywords ***
Merchant Portal Login
    [Arguments]   ${user}=None    ${password}=None
    FOR    ${tag}    IN    @{TEST_TAGS}
        ${is_present}=    Run Keyword And Return Status    List Should Contain Value    ${Instance}    ${tag}
        IF    ${is_present}
            ${base_url}=    Set Variable    ${tag}
        END
    END
    Open Browser    https://${base_url}-qa.mktplacegateway.com/m/login    chrome
    Wait Until Page Contains Element    user-name    30
    IF    '${user}'=='None'
        Input Text    user-name    aditya.chelluru@finmkt.io
    ELSE
        Input Text    user-name    ${user}
    END
    IF    '${password}' == 'None'
        Input Text    user-password    Qa@12345
    ELSE
        Input Text    user-password    ${password}
    END
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div/div[2]/span/form/div/div/div[4]/div/button
