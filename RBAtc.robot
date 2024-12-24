*** Settings ***
Library    SeleniumLibrary
Library    JSONLibrary

*** Test Cases ***
login testcase
    ${data}    Load Json From File    C:/Users/AdityaChelluru/PycharmProjects/testing/TestCases/resource/data.json
    ${username}    Get Value From Json    ${data}    $..username
    ${password}    Get Value From Json    ${data}    $..password
    Open Browser    https://rba-qa.mktplacegateway.com/m/login?r=DC%23    chrome
    Maximize Browser Window
    Input Text    user-name    ${username[0]}
    Input Text    user-password    ${password[0]}
    Click Element    xpath://p[contains(text(),"Submit")]
    Sleep    1
    ${error_msg}=    Get Text    xpath://*[@id="swal2-content"]/b/h2
    ${result}=  Evaluate  "${error_msg}" == "These credentials don\'t match our records."
    Log To Console    ${result}
    Run Keyword If    ${result}     Close Browser

merchant selection and location selection
    Wait Until Page Contains    Please choose from which merchant you want to login    120
    Select From List By Label    xpath://*[@id="merchant-selection-modal___BV_modal_body_"]/div/div/select    Upgrade_Regression
    Wait Until Page Contains    Select Location   120
    Select From List By Label    xpath://*[@id="location-selection-modal___BV_modal_body_"]/div/div/select    Upgrade_Regression_Master

sending application to the customer
    Wait Until Page Contains Element    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div[1]/nav/div[1]/div/div[1]/div/div/button    120
    Wait Until Element Is Enabled    xpath://*[@id="content-wrapper"]/div[1]/nav/div[1]/div/div[1]/div/div/button    10
    Click Button    xpath://*[@id="content-wrapper"]/div[1]/nav/div[1]/div/div[1]/div/div/button
    Switch Window   title:Point Of Sale    20

Selecting a payment option
    Wait Until Page Contains    DEFERRED INTEREST, DEFERRED PAYMENTS    20
    Click Element    R418008
    Input Text    enter-project-cost    10000
    Input Text    enter-deposit-amount    2000
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div/div[2]/div/span/form/span/div/div[2]/div[2]/div/div/div[1]/div/button

credit freeze
    Wait Until Page Contains    Credit Freezes Must Be Lifted To Proceed    30
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/button

will there be a co-applicant?
    Wait Until Page Contains    There is a co-applicant.*    30
    Click Element    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[1]/div/div/div[2]/div/input
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/div/div/button

Terms and conditions
    Wait Until Element Is Visible    webviewer-1    20
    Select Frame    webviewer-1
    Wait Until Element Is Visible    pageWidgetContainer1    10
    Scroll Element Into View    pageWidgetContainer1
    Scroll Element Into View    pageWidgetContainer2
    Scroll Element Into View    pageWidgetContainer3
    Scroll Element Into View    pageWidgetContainer4
    Scroll Element Into View    pageWidgetContainer5
    Scroll Element Into View    pageWidgetContainer6
    Scroll Element Into View    pageWidgetContainer7
    Unselect Frame
    Click Button    clickToSign
    Wait Until Element Is Visible    stylusSignPopup___BV_modal_body_    10
    Click Element    xpath://*[@id="stylusSignPopup___BV_modal_body_"]/div/div[1]/div/div/canvas
    Click Button    xpath://*[@id="stylusSignPopup___BV_modal_body_"]/div/div[2]/div[2]/div/button
    Wait Until Element Is Visible    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div/div/div[3]/div/div/button    20
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div/div/div[3]/div/div/button
    Wait Until Page Contains Element    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[1]    120

credit freeze report
    Wait Until Page Contains    Please click Continue to allow camera access and submit your ID    20
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div/div/div/button
    Wait Until Page Contains    Verify your identity    20
    Click Button    xpath://*[@id="onfido-mount"]/div/div/div[2]/div[2]/div/button

choosing the document
    Wait Until Page Contains    Choose your document    10
    Click Button    xpath://*[@id="onfido-mount"]/div/div/div[2]/div[1]/div[3]/ul/li[3]/button
    Wait Until Page Contains    Submit identity card (front)    20
    Choose File    xpath:.//button[@data-onfido-qa="uploaderButtonLink"][@type="button"]/following-sibling::input[@type="file"]   C:/Users/AdityaChelluru/PycharmProjects/testing/TestCases/resource/DL.jpg
    Wait Until Element Is Visible    xpath://*[@id="onfido-mount"]/div/div/div[2]/div[2]/div/div/button[2]
    Click Button    xpath://*[@id="onfido-mount"]/div/div/div[2]/div[2]/div/div/button[2]

submiting the ID card
    Wait Until Page Contains    Submit identity card (back)    20
    Choose File    xpath://*[@id="onfido-mount"]/div/div/div[2]/div/div[2]/div/div[2]/span/input    C:/Users/AdityaChelluru/PycharmProjects/testing/TestCases/resource/DL.jpg
    Wait Until Element Is Visible    xpath://*[@id="onfido-mount"]/div/div/div[2]/div[2]/div/div/button[2]    10
    Click Button    xpath://*[@id="onfido-mount"]/div/div/div[2]/div[2]/div/div/button[2]

contact information
    Wait Until Element Is Visible    legal-first-name    20
    Execute JavaScript    document.getElementById("legal-first-name").value = "";
    Input Text             xpath://*[@id="legal-first-name"]    Ana
    Execute JavaScript    document.getElementById("legal-last-name").value = "";
    Input Text             xpath://*[@id="legal-last-name"]    Villar
    Input Text    mobile-number    9899999999
    Input Text    email    aditya.chelluru@finmkt.io
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div[2]/div[2]/div/div/div/div/button

installation address
    Wait Until Element Is Visible    address-1    20
    Execute JavaScript    document.getElementById("address-1").value = "";
    Input Text    address-1    11765 West Avenue
    Input Text    city    san antonio
    Select From List By Label    INSTALLATION__ADDRESS__STATE__DROPDOWN    Texas
    Input Text    zipCode    78216
    Select From List By Label    INSTALLATION__ADDRESS__DROPDOWN    Yes, I own this property.
    Select From List By Label    INSTALLATION__ADDRESS__RESIDE__DROPDOWN    Yes, I reside at this address.
    Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/span/form/div[2]/div[2]/div/div/div/div/button
    Wait Until Page Contains    Please Confirm the following is your installation address:    10
    Click Button    xpath://*[@id="address_confirm_modal___BV_modal_body_"]/div/div[2]/div[2]/div[2]/div/button

Billing Address
    Wait Until Page Contains    Billing address is same as installation address.    20
    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/span/form/div[2]/div[1]/div/div[1]/span/div/div/label/input
    Click Element    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/span/form/div[2]/div[1]/div/div[1]/span/div/div/label/span[2]
    Sleep    2
    Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/span/form/div[2]/div[2]/div/div/div/div/button
    Page Should not Contain   Sorry, we are facing a technical issue with one of our data providers.
    Wait Until Page Contains    Your One-Time Passcode has been successfully sent to your mobile phone.    120

OTP Verfication
    Click Button    class:swal2-confirm
    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/div/div/div/span[2]/form/div[1]/div[2]/span/div/input[1]
    Input Text    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/div/div/div/span[2]/form/div[1]/div[2]/span/div/input[1]    1
    Input Text    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/div/div/div/span[2]/form/div[1]/div[2]/span/div/input[2]    2
    Input Text    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/div/div/div/span[2]/form/div[1]/div[2]/span/div/input[3]    3
    Input Text    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/div/div/div/span[2]/form/div[1]/div[2]/span/div/input[4]    4
    Input Text    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/div/div/div/span[2]/form/div[1]/div[2]/span/div/input[5]    5
    Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/div/div/div/span[2]/form/div[2]/div/div/button