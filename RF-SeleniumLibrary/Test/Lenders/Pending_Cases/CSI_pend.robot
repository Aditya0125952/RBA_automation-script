*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot
*** Variables ***
${FFC_DATA}    ${CURDIR}/../../InputData/FF_TestData.json
*** Test Cases ***
CSI Pending - Applicant
    [Tags]    rba5
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
     ${modified_app}=    Copy Dictionary    ${applicant}
    Set To Dictionary    ${modified_app}    FirstName=anaa
    Set Global Variable    ${applicant}   ${modified_app}
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information
    Personal Information
    First Name Re-Kyc Screen
    Handle Initial Flow
    Onfido Page

CSI Pending - Co-Applicant
    [Tags]    rba5    Pend
    ${type}=    Set Variable    coapp
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page
    Type of Application page 
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${co_app_dup}
    Set To Dictionary    ${modified_app}    FirstName=morgan
    Set Global Variable    ${co_app_dup}   ${modified_app}
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information
    Personal Information
    Handle Initial Flow
    Wait Until Element Is Visible    xpath:(//p)[1]    120
    ${co_appurl}=    Get Location
    URL Applicant    ${instance}    ${co_appurl}
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    coapplicant
    Personal Information    coapplicant
    First Name Re-Kyc Screen    ${type}
    Sleep    5
    Handle Initial Flow
    Onfido Page