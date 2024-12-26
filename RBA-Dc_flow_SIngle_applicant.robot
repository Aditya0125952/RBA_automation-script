*** Settings ***
Library    SeleniumLibrary
Library    JSONLibrary
Library    ImapLibrary2

*** Test Cases ***

testing data files
    ${data}    Load Json From File    C:/Users/AdityaChelluru/PycharmProjects/testing/TestCases/resource/data.json
    @{username}    Get Value From Json    ${data}    $..username
    @{password}    Get Value From Json    ${data}    $..password
    FOR    ${name}    IN    @{username}
      Merchant Login    ${name}    
    Merchant selection
    Selecting Location
    sending application to the customer
    selecting payment option
    credit freeze
    will there be any co-applicant
    terms and conditions
    application id scan
    contact information
    installation address
    billing address
    otp verfication
    Email Test
    END








*** Keywords ***
Merchant Login
    [Arguments]    ${username}    
    Open Browser    https://rba-qa.mktplacegateway.com/m/login    chrome
    Wait Until Page Contains Element    user-name    30
    Input Text    user-name    ${username}  # Access the first element of the list
    Input Text    user-password    Qa@12345
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div/div[2]/span/form/div/div/div[4]/div/button

Merchant selection
    Wait Until Element Is Visible    merchant-selection-modal___BV_modal_title_    30
    Select From List By Label        xpath://*[@id="merchant-selection-modal___BV_modal_body_"]/div/div/select    Upgrade_Regression
Selecting Location
    Wait Until Element Is Visible    location-selection-modal___BV_modal_content_    30
    Select From List By Label        xpath://*[@id="location-selection-modal___BV_modal_body_"]/div/div/select    Upgrade_Regression_Master
sending application to the customer
    Wait Until Element Is Enabled    xpath://div[@class='col-md-12 d-flex justify-content-end']//div[@name='Send Application']//div//button[@type='submit'][normalize-space()='Send Application']    30
    Click Button    xpath://div[@class='col-md-12 d-flex justify-content-end']//div[@name='Send Application']//div//button[@type='submit'][normalize-space()='Send Application']
    Switch Window    title:Point Of Sale    20
selecting payment option
    Wait Until Element Is Visible    xpath:/html/body/div/div[2]/div[1]/div/div/div[2]/div/span/form/span/div/div[1]/div/div[1]/h4/b    20
    Click Button    S100617
    Input Text    enter-project-cost    10000
    Input Text    enter-deposit-amount    2000
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div/div[2]/div/span/form/span/div/div[2]/div[2]/div/div/div[1]/div/button
credit freeze
    Wait Until Element Is Enabled    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/button    20
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/button
will there be any co-applicant
    Wait Until Element Is Enabled    xpath://input[@value='1']    20
    Click Button    xpath://input[@value='1']
    Click Button    xpath://button[@type='button']
terms and conditions
    Wait Until Element Is Visible    webviewer-1    20
    Select Frame    webviewer-1
    Wait Until Element Is Visible    xpath://div[@id='pageWidgetContainer1']    20
    Scroll Element Into View    pageWidgetContainer1
    Scroll Element Into View    pageWidgetContainer2
    Scroll Element Into View    pageWidgetContainer3
    Scroll Element Into View    pageWidgetContainer4
    Scroll Element Into View    pageWidgetContainer5
    Scroll Element Into View    pageWidgetContainer6
    Scroll Element Into View    pageWidgetContainer7
    Unselect Frame
    Click Button    clickToSign
    Wait Until Element Is Visible    xpath://div[@class='stylus-sign-div']//canvas
    Click Element    xpath://div[@class='stylus-sign-div']//canvas
    Click Button    xpath://*[@id="stylusSignPopup___BV_modal_body_"]/div/div[2]/div[2]/div/button    
    Wait Until Element Is Enabled       xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div/div/div[3]/div/div/button    10
    Sleep    1
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div/div/div[3]/div/div/button
application id scan
    Wait Until Element Is Visible    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/h4[1]    20
    Wait Until Element Is Enabled    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div/div/div/button    20
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div/div/div/button
    Wait Until Element Is Visible    xpath://h2[normalize-space()='It should take a few minutes']    20
    Click Button    xpath://button[normalize-space()='Start verification']
    Wait Until Element Is Visible    xpath://h1[@class='onfido-sdk-ui-PageTitle-title']    20
    Click Button    //button[@data-onfido-qa='national_identity_card']
    Choose File    xpath://*[@id="onfido-mount"]/div/div/div[2]/div/div[2]/div/div[2]/span/input    C:/Users/AdityaChelluru/PycharmProjects/testing/TestCases/resource/DL.jpg
    Wait Until Element Is Enabled    xpath://button[normalize-space()='Upload']
    Click Button    xpath://button[normalize-space()='Upload']
    Wait Until Element Is Visible    xpath://*[@id="onfido-mount"]/div/div/div[2]/div/div[1]/h1    20
    Choose File    xpath://*[@id="onfido-mount"]/div/div/div[2]/div/div[2]/div/div[2]/span/input    C:/Users/AdityaChelluru/PycharmProjects/testing/TestCases/resource/DL.jpg
    Wait Until Element Is Enabled    xpath://*[@id="onfido-mount"]/div/div/div[2]/div[2]/div/div/button[2]    20
    Click Button    xpath://*[@id="onfido-mount"]/div/div/div[2]/div[2]/div/div/button[2]
contact information
    Wait Until Element Is Visible    legal-first-name    20
    Input Text    legal-first-name    ana
    Execute JavaScript    document.getElementById("legal-last-name").value = "";
    Input Text    legal-last-name    villar
    Input Text    mobile-number    9999999999
    Input Text    email    adityatestingfile@gmail.com
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div[2]/div[2]/div/div/div/div/button
installation address
    Wait Until Element Is Visible    address-1    20
    Execute JavaScript    document.getElementById("address-1").value = "";
    Input Text    address-1    11765 West Avenue
    Input Text    city    San Antonio
    Select From List By Label    INSTALLATION__ADDRESS__STATE__DROPDOWN    Texas
    Input Text    zipCode    78216
    Select From List By Label    xpath://select[@id='INSTALLATION__ADDRESS__DROPDOWN']    Yes, I own this property.
    Select From List By Label    INSTALLATION__ADDRESS__RESIDE__DROPDOWN    Yes, I reside at this address.
    Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/span/form/div[2]/div[2]/div/div/div/div/button
    Wait Until Element Is Visible    xpath://h1[contains(text(),'Please Confirm the following is your installation ')]    20
    Click Button    xpath:/html[1]/body[1]/div[3]/div[1]/div[1]/div[1]/div[1]/div[1]/div[2]/div[2]/div[2]/div[1]/button[1]
billing address
    Wait Until Element Is Enabled    xpath://span[@class='checkmark-sm']    20
    Click Element    xpath://span[@class='checkmark-sm']
    Sleep    3
    Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/span/form/div[2]/div[2]/div/div/div/div/button
otp verfication
    Wait Until Element Is Visible    xpath://*[@id="swal2-html-container"]/b/h3    120
    Click Button    xpath://button[normalize-space()='OK']
    Wait Until Element Is Enabled    xpath://div[@class='row']//input[1]    10
    Input Text    xpath://div[@class='row']//input[1]    1
    Input Text    xpath://div[@class='row']//input[2]    2
    Input Text    xpath://div[@class='row']//input[3]    3
    Input Text    xpath://div[@class='row']//input[4]    4
    Input Text    xpath://div[@class='row']//input[5]    5
    Click Button    xpath:/html[1]/body[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/span[2]/form[1]/div[2]/div[1]/div[1]/button[1]
    Close Browser
email test

    Open Mailbox    host=imap.gmail.com    user=adityatestingfile@gmail.com    password=frtf vfec qzxu fqry
    ${LATEST} =    Wait For Email    sender=noreply@mg.mktplacegateway.com    timeout=300
    Log To Console    ${LATEST}
    Close Mailbox

