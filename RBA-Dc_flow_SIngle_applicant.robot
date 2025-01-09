*** Settings ***
Library    SeleniumLibrary
Library    JSONLibrary
Library    ImapLibrary2

*** Variables ***


*** Test Cases ***
testing data files
    ${data}    Load Json From File    C:/Users/AdityaChelluru/PycharmProjects/testing/none/resource/data.json
    @{username}    Get Value From Json    ${data}    $..username
    @{password}    Get Value From Json    ${data}    $..password
    @{fname}    Get Value From Json    ${data}    $..FN
    @{lname}    Get Value From Json    ${data}    $..LN
    @{address}    Get Value From Json    ${data}    $..Address
    @{city}    Get Value From Json    ${data}    $..city
    @{state}    Get Value From Json    ${data}    $..state
    @{zip}    Get Value From Json    ${data}    $..pin
    @{D0B}    Get Value From Json    ${data}    $..dob
    @{ssn}    Get Value From Json    ${data}    $..ssn
    @{pn}    Get Value From Json    ${data}    $..PN
    @{PC}    Get Value From Json    ${data}    $..pc
    @{DA}    Get Value From Json    ${data}    $..da
    @{AI}    Get Value From Json    ${data}    $..Ai
    @{HI}    Get Value From Json    ${data}    $..Hi
    @{rent}    Get Value From Json    ${data}    $..rent
    @{plan}    Get Value From Json    ${data}    $..plan
    @{email}    Get Value From Json    ${data}    $..email
    FOR    ${name}    IN    @{username}
      Open Browser    https://rba5-qa.mktplacegateway.com/m/login    chrome
      Merchant Login    ${name}
      Merchant selection
      Selecting Location
      sending application to the customer
      selecting payment option    ${PC}    ${DA}    ${plan[0]}
      credit freeze
      will there be any co-applicant
      terms and conditions
      application id scan
      contact information    ${fname}    ${lname}    ${pn}    ${email[0]}
      installation address    ${address[0]}    ${city[0]}    ${state[0]}    ${zip[0]}
      billing address
      otp verfication
      consumer filling the e-consent
      C_credit Freeze
      C_finiancial Information    ${AI}    ${HI}    ${rent}
      C_personal Information    ${ssn}    ${D0B}
      Switch Browser    1
      waiting
      offer approval
    END

*** Keywords ***
Merchant Login
    [Arguments]    ${username}
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
    Sleep    5
    Wait Until Element Is Visible    xpath://div[@class='col-md-12 d-flex justify-content-end']//div[@name='Send Application']//div//button[@type='submit'][normalize-space()='Send Application']    30
    Wait Until Element Is Enabled    xpath://div[@class='col-md-12 d-flex justify-content-end']//div[@name='Send Application']//div//button[@type='submit'][normalize-space()='Send Application']    30
    Click Button    xpath://div[@class='col-md-12 d-flex justify-content-end']//div[@name='Send Application']//div//button[@type='submit'][normalize-space()='Send Application']
    Switch Window    title:Point Of Sale    20
selecting payment option
    [Arguments]    ${PC}    ${DA}    ${plan}
    Wait Until Element Is Visible    xpath:/html/body/div/div[2]/div[1]/div/div/div[2]/div/span/form/span/div/div[1]/div/div[1]/h4/b    20
    Click Button    ${plan}
    Input Text    enter-project-cost    ${PC}
    Input Text    enter-deposit-amount    ${DA}
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div/div[2]/div/span/form/span/div/div[2]/div[2]/div/div/div[1]/div/button
credit freeze
    Wait Until Element Is Enabled    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/button    20
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/button
will there be any co-applicant
    Wait Until Element Is Enabled    xpath://input[@value='1']    20
    Click Button    xpath://input[@value='1']
    Click Button    xpath://button[@type='button']
terms and conditions
    Wait Until Element Is Visible    webviewer-1    60
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
    Choose File    xpath://*[@id="onfido-mount"]/div/div/div[2]/div/div[2]/div/div[2]/span/input    C:/Users/AdityaChelluru/PycharmProjects/testing/TestCases/resource/frontdl.jpg
    Wait Until Element Is Enabled    xpath://button[normalize-space()='Upload']
    Click Button    xpath://button[normalize-space()='Upload']
    Wait Until Element Is Visible    xpath://*[@id="onfido-mount"]/div/div/div[2]/div/div[1]/h1    20
    Choose File    xpath://*[@id="onfido-mount"]/div/div/div[2]/div/div[2]/div/div[2]/span/input    C:/Users/AdityaChelluru/PycharmProjects/testing/TestCases/resource/dlback.jpg
    Wait Until Element Is Enabled    xpath://*[@id="onfido-mount"]/div/div/div[2]/div[2]/div/div/button[2]    20
    Click Button    xpath://*[@id="onfido-mount"]/div/div/div[2]/div[2]/div/div/button[2]
contact information
    [Arguments]    ${fname}    ${lname}    ${pn}    ${email}
    Wait Until Element Is Visible    legal-first-name   120
    Input Text    legal-first-name    ${fname}
    Sleep    1
    Execute JavaScript    document.getElementById("legal-last-name").value = "";
    Input Text    legal-last-name    ${lname}
    Input Text    mobile-number    ${pn}
    Input Text    email    ${email}
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div[2]/div[2]/div/div/div/div/button
installation address
    Sleep    3
    [Arguments]    ${address[0]}    ${city[0]}    ${state[0]}    ${zip[0]}
    Wait Until Element Is Visible    address-1    120
    Execute JavaScript    document.getElementById("address-1").value = "";
    Input Text    address-1    ${address[0]}
    Execute JavaScript    document.getElementById("city").value = "";
    Input Text    city    ${city[0]}
    Select From List By Label    INSTALLATION__ADDRESS__STATE__DROPDOWN     ${state[0]}
    Execute JavaScript    document.getElementById("zipCode").value = "";
    Input Text    zipCode    ${zip[0]}
    Select From List By Label    xpath://select[@id='INSTALLATION__ADDRESS__DROPDOWN']    Yes, I own this property.
    Select From List By Label    INSTALLATION__ADDRESS__RESIDE__DROPDOWN    Yes, I reside at this address.
    Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/span/form/div[2]/div[2]/div/div/div/div/button
    Wait Until Element Is Visible    xpath://h1[contains(text(),'Please Confirm the following is your installation ')]    120
    Click Button    xpath:/html[1]/body[1]/div[3]/div[1]/div[1]/div[1]/div[1]/div[1]/div[2]/div[2]/div[2]/div[1]/button[1]
billing address
    Wait Until Element Is Enabled    xpath://span[@class='checkmark-sm']    180
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

waiting
    Wait Until Element Is Visible    xpath://*[@id="Capa_1"]    120
    Wait Until Element Is Enabled    xpath://*[@id="Capa_1"]    120
    Click Element    xpath://*[@id="Capa_1"]
    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/div[1]/div/button    30
    Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/div[1]/div/button

offer approval
   # Wait Until Element Is Visible    xpath:/html/body/div[1]/div[2]/div[1]/div/div[2]/div/div[1]/div/div/div/div/div    30
    Sleep    120


email test

    Open Mailbox    host=imap.gmail.com    user=adityatestingfile@gmail.com    password=jvmi anfi gdid giuq
    ${LATEST} =    Wait For Email    sender=noreply@mg.mktplacegateway.com    timeout=300
    Log To Console    ${LATEST}
    ${HTML_BODY} =    Walk Multipart Email    ${LATEST}
    ${LINK}=    Get Matches From Email    ${LATEST}    <a[^>]*href=["'](https?://[^"']+)["'][^>]*>.*</a>
    Close Mailbox
    consumer filling the econsent    ${LINK[0]}
    C_credit Freeze
    C_finiancial Information
    C_personal Information


consumer filling the econsent
    [Arguments]    ${LINK}
    Log To Console    ${LINK}
    Open Browser    ${LINK}    chrome
    Wait Until Element Is Visible    webviewer-1    120
    Select Frame    webviewer-1
    Wait Until Element Is Visible    pageWidgetContainer1
    Scroll Element Into View    pageWidgetContainer1
    Scroll Element Into View    pageWidgetContainer2
    Scroll Element Into View    pageWidgetContainer3
    Unselect Frame
    Click Button    clickToSign
    Wait Until Element Is Visible    xpath://div[@class='stylus-sign-div']//canvas
    Click Element    xpath://div[@class='stylus-sign-div']//canvas
    Click Button    xpath://*[@id="stylusSignPopup___BV_modal_body_"]/div/div[2]/div[2]/div/button
    Wait Until Element Is Enabled       xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div/div[3]/div/div/button    10
    Sleep    1
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div/div[3]/div/div/button

C_credit freeze
    Wait Until Element Is Visible    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/button    20
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/button
C_finiancial information
    [Arguments]    ${AI}    ${HI}    ${rent}
    Sleep    2
    Wait Until Element Is Visible    EMPLOYMENT__STATUS    20
    Wait Until Element Is Enabled    EMPLOYMENT__STATUS    20
    Select From List By Label    EMPLOYMENT__STATUS    Retired
   # Wait Until Element Is Visible    occupation    10
    #Wait Until Element Is Enabled    occupation    10
    #Input Text    id:occupation    abc
    #Input Text    employer-name    xyz
    Input Text    monthly-mortgage    ${rent}
    Input Text    annual-income     ${AI}
    Input Text    household-income     ${HI}
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div/div[2]/div/div/div/div/button

C_personal information
    [Arguments]    ${ssn}    ${D0B}
    Sleep    12
    Wait Until Element Is Enabled    name:dob    120
    Input Text    name:dob    ${D0B}
    Input Text    ssn    ${ssn}
    Select From List By Label    CITIZENSHIP_STATUS    US Citizen
    Wait Until Element Is Visible    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div/div[2]/div/div/div/div/button    20
    Wait Until Element Is Enabled    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div/div[2]/div/div/div/div/button    20
    Click Button    xpath://button[@type='submit']
    Wait Until Element Is Visible    xpath://p[normalize-space()='Your application has been received.']    20

consumer filling the e-consent
    Open Browser    https://google.com    chrome
    Sleep   30
    Wait Until Element Is Visible    webviewer-1    120
    Select Frame    webviewer-1
    Wait Until Element Is Visible    pageWidgetContainer1
    Scroll Element Into View    pageWidgetContainer3
    Unselect Frame
    Click Button    clickToSign
    Wait Until Element Is Visible    xpath://div[@class='stylus-sign-div']//canvas
    Click Element    xpath://div[@class='stylus-sign-div']//canvas
    Click Button    xpath://*[@id="stylusSignPopup___BV_modal_body_"]/div/div[2]/div[2]/div/button
    Wait Until Element Is Enabled       xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div/div[3]/div/div/button    10
    Sleep    1
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div/div[3]/div/div/button
