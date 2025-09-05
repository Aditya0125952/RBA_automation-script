*** Settings ***
Library    SeleniumLibrary

*** Variables ***
@{Instance}
...    rba    rba2    rba3    rba4    rba5    rba6
${base_url}    rba

*** Keywords ***
URL Applicant
    [Arguments]    ${type}=None
    FOR    ${tag}    IN    @{TEST_TAGS}
        ${is_present}=    Run Keyword And Return Status    List Should Contain Value    ${Instance}    ${tag}
        IF    ${is_present}
            ${base_url}=    Set Variable    ${tag}
        END
    END
    ${is_CoApp}=    Run Keyword And Return Status    Should Contain    ${TEST TAGS}    Co-App
    IF   ${is_CoApp} and '${type}'!='None'
        ${url}=    Get Location
        ${match}=    Evaluate    __import__('re').findall(r'[a-z0-9\-]{24,36}', '''${url}''')
        Log To Console    ${match}
        ${M_URL}=  Set Variable    https://${base_Url}-qa.mktplacegateway.com/c/application-authorization?loanId=${match[-1]}&type=CO_APPLICANT&m=${Merchant_ID}&locationId=${Location_ID}
    ELSE
        ${M_URL}=  Set Variable    https://${base_Url}-qa.mktplacegateway.com/c/application-authorization?appId=${APP_ID}&type=APPLICANT&m=${Merchant_ID}&locationId=${Location_ID}
    END

    Execute JavaScript    window.open('${M_URL}', '_blank')
    Switch Window    NEW

    #Open Browser    ${M_URL}    chrome
    ${location}=    Get Location
    Log To Console    this is the location  ${location}