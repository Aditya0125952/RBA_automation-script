*** Settings ***
Library    SeleniumLibrary
Resource    C:/Users/AdityaChelluru/PycharmProjects/Test/common_pages/common_Resoucres.robot

*** Variables ***
${GL_DATA}     C:/Users/AdityaChelluru/PycharmProjects/Test/InputData/GL_applicants_list.json
${START_DIGITS}    888

*** Test Cases ***
Good Leap HappyCase
    Load Lender Data    ${GL_DATA}    1196
    Merchant Portal Login
    Merchant Selection Page    RBA_GL_FFC_DIV_PP
    Selecting The Merchant Location    RBA_GL_FFC_DIV_PP_Master
    Sending Application to Consumer
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
    ${number}=    Generate Phone Number Starting With 888
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    mobileNumber=${number}
    #Set To Dictionary    ${modified_app}    employment_status=Employed
    Set Global Variable    ${application}    ${modified_app}
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information
    Personal Information
    Handle Initial Flow




    
Good Leap Counter Offer Case
    Set Global Variable    ${index}   1246
    Load Lender Data    ${GL_DATA}    ${index}
    Merchant Portal Login
    Merchant Selection Page
    Selecting The Merchant Location
    Sending Application to Consumer
    Dc plans page    60000
    Type of Application page
    Load and Prepare applicant details
    ${number}=    Generate Phone Number Starting With 888
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    mobileNumber=${number}
    Set Global Variable    ${application}    ${modified_app}
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information
    Personal Information
    Handle Initial Flow

*** Keywords ***
Generate Phone Number Starting With 888
    ${random_part}=    Evaluate    ''.join(__import__('random').choices('0123456789', k=7))
    ${phone_number}=    Catenate    SEPARATOR=    ${START_DIGITS}    ${random_part}
    [Return]    ${phone_number}