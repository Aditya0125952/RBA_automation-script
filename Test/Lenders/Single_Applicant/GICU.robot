*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot

*** Variables ***
${GICU_DATA}    ${CURDIR}/../../InputData/GICU_TestData.json
${instance}    rba5

*** Test Cases ***
GICU Happycase
    [Tags]    ${instance}    R412007
    Load Lender Data    ${GICU_DATA}
    Merchant Portal Login
    Merchant Selection Page
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
    Address Re-Kyc Screen
    Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button
    Handle Initial Flow