*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot

*** Variables ***
${GL_DATA}     ${CURDIR}/../../InputData/GL_applicants_list.json
${START_DIGITS}    888
${instance}    rba4

*** Test Cases ***
Upgrade HappyCase
    [Tags]    S100617    ${instance}
    Load Lender Data    ${GL_DATA}    1238
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI  
    #Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page    21000    10
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    ${unique}=    unique Email
    Set To Dictionary    ${modified_app}    email=aditya.chelluru+${unique}@finmkt.io
   # Set To Dictionary    ${modified_app}    employment_status=Not Employed
    #Set To Dictionary    ${modified_app}    dob=04/01/1982
    Set Global Variable    ${application}    ${modified_app}
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information
    Personal Information
    #Sleep    100
    Handle Initial Flow

Upgrade HappyCase
    [Tags]    S100617    ${instance}
    Load Lender Data    ${GL_DATA}    1238
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI  
    #Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page    21000    10
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    ${unique}=    unique Email
    Set To Dictionary    ${modified_app}    email=aditya.chelluru+${unique}@finmkt.io
   # Set To Dictionary    ${modified_app}    employment_status=Not Employed
    #Set To Dictionary    ${modified_app}    dob=04/01/1982
    Set Global Variable    ${application}    ${modified_app}
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information
    Personal Information
    #Sleep    100
    Handle Initial Flow


*** Keywords ***
unique Email
    ${random_part}=    Evaluate    ''.join(__import__('random').choices('0123456789', k=4))
    [Return]    ${random_part}
