*** Settings ***
Library    SeleniumLibrary
Resource    C:/Users/AdityaChelluru/PycharmProjects/Test/common_pages/common_Resoucres.robot
*** Variables ***
${Sunlight_DATA}    C:/Users/AdityaChelluru/PycharmProjects/Test/InputData/Sunlight_TestData.json

*** Test Cases ***
Sunlight HappyCase
    Load Lender Data    ${Sunlight_DATA}
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