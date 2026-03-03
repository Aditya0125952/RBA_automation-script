*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot
*** Variables ***
${Sunlight_DATA}    ${CURDIR}/../../InputData/Sunlight_TestData.json
${instance}    rba6

*** Test Cases ***
Sunlight HappyCase
    [Tags]    ${instance}    S100617
    Load Lender Data    ${Sunlight_DATA}
    Merchant Portal Login    
    Merchant Selection Page    Sunlight_HI
    selecting the merchant location    Sunlight_HI_Primary   
    Sending Application to Consumer    
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    email=lalith.buddha@finmkt.io
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

SUNLIGHT Ownership_Stipulation
    [Tags]    ${instance}    S101817
    Load Lender Data    ${Sunlight_DATA}
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI
    selecting the merchant location    Sunlight_HI_Master
    Sending Application to Consumer
    Dc plans page    76000    0
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    email=wesly.thoram@finmkt.io
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

Sunlight DTI Failure Case
    [Tags]    ${instance}    R418006
    Load Lender Data    ${Sunlight_DATA}
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI
    Sending Application to Consumer
    Dc plans page    250000    0
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    email=aditya.chelluru+1@finmkt.io
    Set To Dictionary    ${modified_app}    annual_income=100000
    Set To Dictionary    ${modified_app}    household_income=100000
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