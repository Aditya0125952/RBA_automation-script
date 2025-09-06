*** Settings ***
Library    SeleniumLibrary
Resource    C:/Users/AdityaChelluru/Desktop/github/RBA_automation-script/Test/common_pages/common_Resoucres.robot

*** Variables ***
${GL_DATA}     C:/Users/AdityaChelluru/Desktop/github/RBA_automation-script/Test/InputData/GL_applicants_list.json
${START_DIGITS}    888

*** Test Cases ***
Upgrade HappyCase
    [Tags]    R418008    rba6
    Load Lender Data    ${GL_DATA}    1121
    Merchant Portal Login
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page    21000    10
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    email=aditya.chelluru+2005@finmkt.io
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
