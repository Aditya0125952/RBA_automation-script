*** Settings ***
Library    SeleniumLibrary

*** Variables ***


*** Test Cases ***
Login Test
    Open Browser    https://finfi-qa.mktplacegateway.com/login/MERCHANT    chrome
    Wait Until Element Is Visible    emailInput    120
    Input Text    emailInput    satish.mallavarapu@finmkt.io
    Input Text    passwordInput    Qa@12345
    Click Element    emailSubmit
    Wait Until Element Is Visible    appendVendors    180

Merchant selection test
    Select From List By Label    appendVendors    FINFI_OMF

Sending Application to the customer
    Click Button    Send Application
    Wait Until Element Is Visible    xpath://*[@id="loanReffLinkModal"]/div/div/div[2]/p[2]    120
    referal credentials
    Sleep     3
    

*** Keywords ***
referal credentials
    Input Text    refLinkEmail    aditya.chelluru@finmkt.io
    Input Text    refLoanAmount    10000
    Select From List By Label    selectedSubProgramName    HVAC
    Select From List By Label    refOffCodes    OMF
    Click Element    xpath://*[@id="loanReffLinkModal"]/div/div/div[3]/button
