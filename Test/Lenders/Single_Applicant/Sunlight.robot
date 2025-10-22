*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot
*** Variables ***
${Sunlight_DATA}    ${CURDIR}/../../InputData/Sunlight_TestData.json
${instance}    rba2

*** Test Cases ***
Sunlight HappyCase
    [Tags]    ${instance}    R418006
    Load Lender Data    ${Sunlight_DATA}
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI
    Sending Application to Consumer
    Dc plans page    21000    0
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    email=aditya.chelluru@finmkt.io
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