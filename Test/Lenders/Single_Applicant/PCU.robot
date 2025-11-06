*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot
Library         JSONLibrary  # Needed for parsing
Library         BuiltIn
*** Variables ***
${PCU_DATA}    ${CURDIR}/../../InputData/PCU_TestData.json
${INSTANCE}    rba

*** Test Cases ***
PCU HappyCase
    [Tags]    ${instance}    R412005
    Load Lender Data    ${PCU_DATA}
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