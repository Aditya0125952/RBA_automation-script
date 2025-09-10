*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot
*** Variables ***
${FFC_DATA}    ${CURDIR}/../../InputData/FF_TestData.json

*** Test Cases ***
FFC HappyCase
    [Tags]    rba6    R418008
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI
    #Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page    23678    6
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
