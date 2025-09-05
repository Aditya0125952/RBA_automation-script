*** Settings ***
Library    SeleniumLibrary
Resource    C:/Users/AdityaChelluru/PycharmProjects/Test/common_pages/common_Resoucres.robot

*** Variables ***
${GICU_DATA}    C:/Users/AdityaChelluru/PycharmProjects/Test/InputData/GICU_TestData.json


*** Test Cases ***
GICU Happycase
    [Tags]    R412004    rba5    Co-App
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
    Wait Until Element Is Visible    xpath:(//p)[1]    120
    URL Applicant    Co-App
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    Co-App
    Personal Information    Co-App
    Sleep    5
    Handle Initial Flow