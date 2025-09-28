*** Settings ***
Library    SeleniumLibrary

*** Variables ***
@{Instance}
...    rba    rba2    rba3    rba4    rba5    rba6
${base_url}    rba

*** Keywords ***
URL Applicant
    FOR    ${tag}    IN    @{TEST_TAGS}
        ${is_present}=    Run Keyword And Return Status    Should Start With    ${tag}    rba
        IF    ${is_present}
            ${base_url}=    Set Variable    ${tag}
            Exit For Loop
        END
    END
    ${url}=    Get Location
    ${loan_id_is_present}=    Run Keyword And Return Status    Should Contain    ${url}    loanId=
    #${is_CoApp}=    Run Keyword And Return Status    Should Contain    ${TEST TAGS}    Co-App
    IF   ${loan_id_is_present}
        ${match}=    Evaluate    __import__('re').findall(r'loanId=([a-z0-9\-]{24,36})', '''${url}''')
        Log To Console    ${match}
        ${M_URL}=  Set Variable    https://${base_Url}-qa.mktplacegateway.com/c/application-authorization?loanId=${match[0]}&type=CO_APPLICANT&m=${Merchant_ID}&locationId=${Location_ID}
    ELSE
        ${M_URL}=  Set Variable    https://${base_Url}-qa.mktplacegateway.com/c/application-authorization?appId=${APP_ID}&type=APPLICANT&m=${Merchant_ID}&locationId=${Location_ID}
    END

    Execute JavaScript    window.open('${M_URL}', '_blank')
    Switch Window    NEW

    #Open Browser    ${M_URL}    chrome
    ${location}=    Get Location
    Log To Console    this is the location  ${location}