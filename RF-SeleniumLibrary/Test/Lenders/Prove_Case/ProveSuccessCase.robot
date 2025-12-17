*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot
*** Variables ***
${Prove_DATA}    ${CURDIR}/../../InputData/Prove_Success_TestData.json

*** Test Cases ***
Prove HappyCase
    [Tags]    Prove    rba5    S100617
    Load Lender Data    ${Prove_DATA}    0
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI
    #Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page    21000    0
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
    SSN Re-Kyc Screen
    Handle Initial Flow
    
Co-Applicant Happy path for prove
    [Tags]    Prove    rba    S100617    Co-App
    Load Lender Data    ${Prove_DATA}
    Merchant Portal Login
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page    21000    0
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
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data    Co-App
    Basic Information    Co-App 
    Personal Information    Co-App
    Wait Until Element Is Not Visible    xpath:/html/body/div/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div[3]/div/div/button    20
    Handle Initial Flow