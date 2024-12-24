*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${c_browser}    chrome
${c_url}    https://app-qa.finfi.co/gateway-pos/finfi/create-loan/CONSUMER_POS?merchant=6530d4f2c54eaa995507b7b1&offerCode=66d02dc2c54eaa969a601712&loanAmount=10000&pId=5c86c1dd3fe07d3f675d9417&spId=5cb112103fe07d72716dc548&appId=f562620b-4d4c-4fe1-8965-f54c84946bcc

*** Test Cases ***
Customer application personal details
    Open Browser    ${c_url}    ${c_browser}
    customer details
    Wait Until Element Is Visible     appGrossIncome    180
    
additional customer details
    Input Text    appGrossIncome    100000
    Select From List By Label    employmentStatus    Employed
    Input Text    monthlyMortgage    100
    Input Text    ssnInput    666682230
    Click Element    xpath://*[@id="create-loan"]/div[4]/div/div/div/div/label/span
    Click Button    consumerAppSubmit
hitting a snag
    Wait Until Page Contains Element    consumerAppSubmit    120
    Input Text    applicant-dateOfBirth    10/31/1949
    Click Button    consumerAppSubmit
Offer Selection
    Wait Until Page Contains Element    xpath:/html/body/div/section/header/div/div/div/div[2]/h3[2]    120
    #sleep  120
    Click Element    css:.radioCheck
    sleep  2
    Click Button    accOffer
    #Sleep    100
    Wait Until Page Contains    Please Confirm    10
    Click Button    xpath://Button[contains(text(),"Confirm")]
next part of the application
    Wait Until Element Is Visible    xpath://*[@id="no-offers-heading"]  10
    Click Button    xpath://Button[contains(text(),"Continue")]
    #Sleep    300

onfido verfication
    Wait Until Element Is Visible    xpath:/html/body/div/section/header/div/div/h3[2]/b    100
    Click Element    xpath://a[contains(text(),"browse")]
    Choose File    //*[@id="fileInput"]    C:/Users/AdityaChelluru/PycharmProjects/testing/TestCases/resource/DL.jpg
    sleep  10
    Click Button    uploadBtnId
    sleep  5


*** Keywords ***
customer details
    Input Text    firstName    james
    Input Text    lastName    kline
    Input Text    xpath://*[@id="appEmail"]    aditya.chelluru@finmkt.io
    Input Text    autocomplete    418 Clubhouse Road
    Input Text    xpath://*[@id="locality"]    Curtice
    Select From List By Label    id:stateDropdown    Ohio
    Input Text    zipcode    43412
    Input Text    mobile-phone    9899999999
    Input Text    applicant-dateOfBirth    10/31/1949
    Select From List By Label    id:uscitizenship    Yes, I own this property
    Select From List By Label    xpath:/html/body/div[1]/section/div/main/form/div[8]/div[1]/div/div/div[2]/div/select     Yes, I reside at this property
    Click Element    xpath://*[@id="create-loan"]/header/div/div/label
    Click Button    consumerAppSubmit

