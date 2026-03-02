*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot

*** Variables ***
${GL_DATA}     ${CURDIR}/../../InputData/GL_applicants_list.json
${START_DIGITS}    888
${instance}    rba6
#for succes case
#${SSN}    500101 
#for failure case
${SSN}    500205 

*** Test Cases ***
GL HappyCase
    [Tags]    ${instance}   R412004
    Load Lender Data    ${GL_DATA}    171
    Merchant Portal Login
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
    ${number}=    Generate Phone Number Starting With 888
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    mobileNumber=${number}
    #Set To Dictionary    ${modified_app}    email=varshitha.suryapalli@finmkt.io
    Set Global Variable    ${application}    ${modified_app}
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information
    Personal Information
    Handle Initial Flow




    
Good Leap Counter Offer Case
    Set Global Variable    ${index}   1248
    Load Lender Data    ${GL_DATA}    ${index}
    Merchant Portal Login
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page    60000    0
    Type of Application page
    Load and Prepare applicant details
    ${number}=    Generate Phone Number Starting With 888
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    mobileNumber=${number}
    Set Global Variable    ${application}    ${modified_app}
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information
    Personal Information
    Handle Initial Flow



GL HappyCase by changining ssn
    [Tags]    ${instance}    S100617
    Load Lender Data    ${GL_DATA}    165
    Merchant Portal Login    aditya.chelluru+123@finmkt.io    Qa@12345
    #Merchant Selection Page     
    #Selecting The Merchant Location       
    Sending Application to Consumer
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
    ${number}=    Generate Phone Number Starting With 888
    ${ssn}=    GL SSN First and Last
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    mobileNumber=${number}
    Set To Dictionary    ${modified_app}    ssn=${ssn}
   # Set To Dictionary    ${modified_app}    email=saranya.pentapati@finmkt.io
    Set Global Variable    ${application}    ${modified_app}
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information
    Personal Information
    SSN Re-Kyc Screen
    Handle Initial Flow


*** Keywords ***
Generate Phone Number Starting With 888
    ${random_part}=    Evaluate    ''.join(__import__('random').choices('0123456789', k=7))
    ${phone_number}=    Catenate    SEPARATOR=    ${START_DIGITS}    ${random_part}
    [Return]    ${phone_number}

Generate unqiue ssn
    ${random_part}=    Evaluate    ''.join(__import__('random').choices('0123456789', k=3))
    ${phone_number}=    Catenate    SEPARATOR=    ${SSN}    ${random_part}
    [Return]    ${phone_number}

GL SSN First and Last
    ${first}=    Evaluate    ''.join(__import__('random').choices('12345', k=1))
    ${last}=    Evaluate    ''.join(__import__('random').choices('123456789', k=1))
    ${phone_number}=    Catenate    SEPARATOR=    ${first}    0010211    ${last}
    Log To Console      ${phone_number}
    [Return]    ${phone_number}