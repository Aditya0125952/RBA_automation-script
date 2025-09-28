*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot
*** Variables ***
${FFC_DATA}    ${CURDIR}/../../InputData/GICU_TestData.json
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
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information
    Personal Information
    Handle Initial Flow
    Onfido Page

CSI Pending - Co-Applicant
    Set Global Variable    ${type}    coapp
    Set Global Variable    ${instance}    rba6
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login    ${instance}
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page
    Type of Application page    ${type}
    Load and Prepare applicant details    coapp
    ${modified_app}=    Copy Dictionary    ${co_app_dup}
    Set To Dictionary    ${modified_app}    FirstName=morgan
    Set Global Variable    ${co_app_dup}   ${modified_app}
    Application Details Page    ${type}
    Verification Info Pop-up    ${type}
    URL Applicant    ${instance}
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