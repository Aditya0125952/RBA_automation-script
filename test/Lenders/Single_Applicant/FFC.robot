*** Settings ***
Library    SeleniumLibrary
Resource    C:/Users/AdityaChelluru/PycharmProjects/Test/common_pages/common_Resoucres.robot
*** Variables ***
${FFC_DATA}    C:/Users/AdityaChelluru/PycharmProjects/Test/InputData/FF_TestData.json

*** Test Cases ***
FFC HappyCase
    [Tags]    rba6    S100617
    Load Lender Data    ${FFC_DATA}
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


FFC Counter Offer Casre
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page    155000    0
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
