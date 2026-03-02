*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot

*** Variables ***
${FFC_DATA}    ${CURDIR}/../../InputData/FF_TestData.json
${INSTANCE}    rba4
*** Test Cases ***
First Name Pending - Applicant
    [Tags]    Pend    ${INSTANCE} 
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login   
    Merchant Selection Page    Sunlight_HI
    Selecting The Merchant Location    Sunlight_HI_Master
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
    #Last Name Re-Kyc Screen
    #Handle Initial Flow
    Onfido Page

First Name Pending - Co-Applicant (Primary Applicant)
    [Tags]   rba6    Co-App    S100617
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI
    Selecting The Merchant Location    Sunlight_HI_Master
    Sending Application to Consumer
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    FirstName=anaa
    Set Global Variable    ${application}    ${modified_app}
     #${modified_app}=    Copy Dictionary    ${co_app_dup}
    #Set To Dictionary    ${modified_app}    FirstName=morgan
    #Set Global Variable    ${co_app_dup}   ${modified_app}
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
    #Sleep    25
    #Wait Until Element Is Visible    xpath:(//p)[1]    120
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    Co-App
    Personal Information    Co-App
    First Name Re-Kyc Screen    Co-App
    #Sleep    5
    Handle Initial Flow
    Onfido Page

First Name Pending - Co-Applicant
    [Tags]    Pend    rba6    Co-App
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI
    Selecting The Merchant Location    Sunlight_HI_Master
    Sending Application to Consumer
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${co_app_dup}
    Set To Dictionary    ${modified_app}    dob=05/01/1986
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
    DOB Re-Kyc Screen    Co-App
    Sleep    5
    Handle Initial Flow
    Onfido Page