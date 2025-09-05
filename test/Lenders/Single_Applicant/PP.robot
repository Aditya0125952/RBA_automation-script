*** Settings ***
Library    SeleniumLibrary
Resource    C:/Users/AdityaChelluru/PycharmProjects/Test/common_pages/common_Resoucres.robot

*** Variables ***
${PP_DATA}     C:/Users/AdityaChelluru/PycharmProjects/Test/InputData/PP_TestData.json
${GL_DATA}     C:/Users/AdityaChelluru/PycharmProjects/Test/InputData/GL_applicants_list.json

*** Test Cases ***
PowerPay Happy Flow
    [Tags]    rba6    S101217
    Load Lender Data    ${PP_DATA}
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