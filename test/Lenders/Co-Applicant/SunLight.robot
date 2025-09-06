*** Settings ***
Library    SeleniumLibrary
Resource    C:/Users/AdityaChelluru/Desktop/github/RBA_automation-script/Test/common_pages/common_Resoucres.robot

*** Variables ***
${FFC_DATA}     C:/Users/AdityaChelluru/Desktop/github/RBA_automation-script/Test/InputData/FF_TestData.json
${START_DIGITS}    888

*** Test Cases ***
Sunlight HappyCase
    [Tags]    rba5    Co-App
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI
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
    Wait Until Element Is Visible    xpath:(//p)[1]    120
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    Co-App
    Personal Information    Co-App
    Sleep    5
    Handle Initial Flow
