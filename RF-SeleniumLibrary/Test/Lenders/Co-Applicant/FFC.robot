*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot

*** Variables ***
${FFC_DATA}     ${CURDIR}/../../InputData/FF_TestData.json
${START_DIGITS}    888
${instance}    rba6

*** Test Cases ***
FFC HappyCase
    [Tags]    R418006    ${instance}   Co-App
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI 
    Selecting The Merchant Location    Sunlight_HI_Master
    Sending Application to Consumer
    Dc plans page    28000    1000
    Type of Application page
    Load and Prepare applicant details
    ${modified_app1}=    Copy Dictionary    ${application}
    ${modified_app2}=    Copy Dictionary    ${co_app_dup}
     #Set To Dictionary    ${modified_app1}    mobileNumber=8889271987
     Set To Dictionary    ${modified_app1}    email=aditya.chelluru+6761@finmkt.io
     Set To Dictionary    ${modified_app2}    email=aditya.chelluru+2827@finmkt.io
    Set Global Variable    ${co_app_dup}    ${modified_app2}
    Set Global Variable    ${application}    ${modified_app1}
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
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    Co-App
    Sleep    60    
    Personal Information    Co-App
    Handle Initial Flow



*** Keywords ***
Generate Phone Number Starting With 888
    ${random_part}=    Evaluate    ''.join(__import__('random').choices('0123456789', k=7))
    ${phone_number}=    Catenate    SEPARATOR=    ${START_DIGITS}    ${random_part}
    [Return]    ${phone_number}
