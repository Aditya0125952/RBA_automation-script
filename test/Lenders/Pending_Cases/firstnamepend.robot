*** Settings ***
Library    SeleniumLibrary
Resource    C:/Users/AdityaChelluru/Desktop/github/RBA_automation-script/Test/common_pages/common_Resoucres.robot

*** Variables ***
${FFC_DATA}    C:/Users/AdityaChelluru/Desktop/github/RBA_automation-script/Test/InputData/FF_TestData.json
*** Test Cases ***
First Name Pending - Applicant
    [Tags]    Pend    rba5
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    FirstName=Anaa
    Set Global Variable    ${application}    ${modified_app}
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

First Name Pending - Co-Applicant (Primary Applicant)
    [Tags]    Pend    rba5    Co-App
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    FirstName=Anaa
    Set Global Variable    ${application}    ${modified_app}
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
    Wait Until Element Is Visible    xpath:(//p)[1]    120
    URL Applicant    Co-App
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    Co-App
    Personal Information    Co-App
    First Name Re-Kyc Screen    Co-App
    Sleep    5
    Handle Initial Flow
    #Onfido Page

First Name Pending - Co-Applicant
    [Tags]    Pend    rba5    Co-App
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
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    Co-App
    Personal Information    Co-App
    First Name Re-Kyc Screen    Co-App
    Sleep    5
    Handle Initial Flow
    Onfido Page