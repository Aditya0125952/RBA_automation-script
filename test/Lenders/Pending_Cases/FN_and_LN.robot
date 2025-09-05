*** Settings ***
Library    SeleniumLibrary
Resource    C:/Users/AdityaChelluru/PycharmProjects/Test/common_pages/common_Resoucres.robot

*** Variables ***
${FFC_DATA}    C:/Users/AdityaChelluru/PycharmProjects/Test/InputData/FF_TestData.json

*** Test Cases ***
Last Name Pending - Applicant
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}     FirstName=anaa
    Set To Dictionary    ${modified_app}     LastName=Villarr
    Set Global Variable    ${application}    ${modified_app}
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information
    Personal Information
    LN And FN Re-kyc Screen
    Handle Initial Flow
    Onfido Page

Last Name Pending - Co-Applicant
    Set Global Variable    ${type}    coapp
    Set Global Variable    ${instance}    rba
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login    ${instance}
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page
    Type of Application page    ${type}
    Load and Prepare applicant details    coapp
    ${modified_app}=    Copy Dictionary    ${co_app_dup}
    Set To Dictionary    ${modified_app}    LastName=Black
    Set Global Variable    ${co_app_dup}   ${modified_app}
    Application Details Page    ${type}
    Verification Info Pop-up    ${type}
    URL Applicant    ${instance}
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information
    Personal Information
    Handle Initial Flow    coapplicant
    Wait Until Element Is Visible    xpath:(//p)[1]    120
    ${co_appurl}=    Get Location
    URL Applicant    ${instance}    ${co_appurl}
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    coapplicant
    Personal Information    coapplicant
    Last Name Re-Kyc Screen    ${type}
    Sleep    5
    Handle Initial Flow
    Onfido Page