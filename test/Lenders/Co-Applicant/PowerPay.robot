*** Settings ***
Library    SeleniumLibrary
Resource    C:/Users/AdityaChelluru/PycharmProjects/Test/common_pages/common_Resoucres.robot

*** Variables ***
${PP_DATA}     C:/Users/AdityaChelluru/PycharmProjects/Test/InputData/PP_TestData.json
${START_DIGITS}    888

*** Test Cases ***
PowerPay HappyCase
    [Tags]    rba6    Co-App    S101217
    Load Lender Data    ${PP_DATA}
    Merchant Portal Login
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page    20000    10
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
    ${co_appurl}=    Get Location
    URL Applicant    Co-App
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    Co-App
    Personal Information    Co-App
    Handle Initial Flow



*** Keywords ***
Generate Phone Number Starting With 888
    ${random_part}=    Evaluate    ''.join(__import__('random').choices('0123456789', k=7))
    ${phone_number}=    Catenate    SEPARATOR=    ${START_DIGITS}    ${random_part}
    [Return]    ${phone_number}