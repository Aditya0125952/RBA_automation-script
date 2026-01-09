*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot

*** Variables ***
${PP_DATA}     ${CURDIR}/../../InputData/PP_TestData.json
${INSTANCE}    rba2

*** Test Cases ***
PP HappyCase
    [Tags]    ${INSTANCE}    R418009
    Load Lender Data    ${PP_DATA}
    Merchant Portal Login    prathyusha.dumala@finmkt.io    Qa@12345
    Merchant Selection Page    RBA_GL_FFC_DIV_PP
    Selecting The Merchant Location    RBA_GL_FFC_DIV_PP_Master
    Sending Application to Consumer
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    #Set To Dictionary    ${modified_app}    email=prathyusha.dumala@finmkt.io
    #Set To Dictionary    ${modified_app}    citizenship_status=Other
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

PP Conditional Approval
    [Tags]    ${INSTANCE}    R418009
    Load Lender Data    ${CURDIR}/../../InputData/PP_Conditional_Approval_TestData.json
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI
    Selecting The Merchant Location    Sunlight_HI_Master
    Sending Application to Consumer
    Dc plans page    21000    0
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    email=aditya.chelluru@finmkt.io
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