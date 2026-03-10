*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot

*** Variables ***
${GL_DATA}     ${CURDIR}/../../InputData/GL_applicants_list.json
${START_DIGITS}    888
${instance}    rba6

*** Test Cases ***
Good Leap HappyCase
    [Tags]    ${instance}    Co-App
    Load Lender Data    ${GL_DATA}    1241    1243
    Merchant Portal Login    
    Merchant Selection Page    RBA_GL_FFC_DIV_PP
    Selecting The Merchant Location    RBA_GL_FFC_DIV_PP_Master
    Sending Application to Consumer
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
    ${number1}=    Generate Phone Number Starting With 888
    ${number2}=    Generate Phone Number Starting With 888
    ${modified_app1}=    Copy Dictionary    ${application}
    ${modified_app2}=    Copy Dictionary    ${co_app_dup}
    Set To Dictionary    ${modified_app2}    mobileNumber=${number2}
    Set To Dictionary    ${modified_app1}    mobileNumber=${number1}
    Set Global Variable    ${co_app_dup}    ${modified_app2}
    Set Global Variable    ${application}    ${modified_app1}
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information
    ${last3}=    Evaluate    "${application['ssn']}[-3:]"
    ${final_number}=    Catenate    SEPARATOR=    500205    ${last3}
    Log To Console    Final Number: ${final_number}
    Personal Information
    Handle Initial Flow
    Wait Until Element Is Visible    xpath:(//p)[1]    120
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    Co-App
    Personal Information    Co-App
    Handle Initial Flow
Good leap Co-App flow(ssn_change) Happy flow
    [Tags]    rba6    Co-App    S100617
    Load Lender Data    ${GL_DATA}    72    174
    Merchant Portal Login 
    Merchant Selection Page    Sunlight_HI
    Selecting The Merchant Location    Sunlight_HI_Primary
    Sending Application to Consumer
    Dc plans page
    Type of Application page 
    Load and Prepare applicant details
    ${number1}=    Generate Phone Number Starting With 888
    ${number2}=    Generate Phone Number Starting With 888
    ${modified_app1}=    Copy Dictionary    ${application}
    ${modified_app2}=    Copy Dictionary    ${co_app_dup}
    Set To Dictionary    ${modified_app2}    mobileNumber=${number2}
    Set To Dictionary    ${modified_app1}    mobileNumber=${number1}
    Set Global Variable    ${co_app_dup}    ${modified_app2}
    Set Global Variable    ${application}    ${modified_app1}
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    SSN Changing for co-app
    Prove Data
    Basic Information
    Personal Information
    SSN Re-Kyc Screen
    Handle Initial Flow
    Wait Until Element Is Visible    xpath:(//p)[1]    120
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    Co-App
    Personal Information    Co-App
    SSN Re-Kyc Screen    Co-App
    Handle Initial Flow
GoodLeap applicant Drop case
    [Tags]    rba4    Co-App
    Load Lender Data    ${GL_DATA}    69    122
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI
    Selecting The Merchant Location    Sunlight_HI_Master
    Sending Application to Consumer
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
    ${number1}=    Generate Phone Number Starting With 888
    ${number2}=    Generate Phone Number Starting With 888
    ${modified_app1}=    Copy Dictionary    ${application}
    ${modified_app2}=    Copy Dictionary    ${co_app_dup}
    Set To Dictionary    ${modified_app2}    mobileNumber=${number2}
    Set To Dictionary    ${modified_app1}    mobileNumber=${number1}
    Set Global Variable    ${co_app_dup}    ${modified_app2}
    Set Global Variable    ${application}    ${modified_app1}
    Application Details Page
    Verification Info Pop-up
    URL Applicant       
    Application Authorization Page
    Credit Freeze Page
    SSN Change for Applicant Drop
    Prove Data
    Basic Information
    Personal Information
    SSN Re-Kyc Screen
    Handle Initial Flow
    Wait Until Element Is Visible    xpath:(//p)[1]    120
    ${co_appurl}=    Get Location
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    Co-App
    Personal Information    Co-App
    SSN Re-Kyc Screen    Co-App
    Handle Initial Flow

GoodLeap co-applicant Drop case
    [Tags]    rba4    Co-App
    Load Lender Data    ${GL_DATA}    188    201
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI
    Selecting The Merchant Location    Sunlight_HI_Master
    Sending Application to Consumer
    Dc plans page
    Type of Application page
    Load and Prepare applicant details
    ${number1}=    Generate Phone Number Starting With 888
    ${number2}=    Generate Phone Number Starting With 888
    ${modified_app1}=    Copy Dictionary    ${application}
    ${modified_app2}=    Copy Dictionary    ${co_app_dup}
    Set To Dictionary    ${modified_app2}    mobileNumber=${number2}
    Set To Dictionary    ${modified_app1}    mobileNumber=${number1}
    Set Global Variable    ${co_app_dup}    ${modified_app2}
    Set Global Variable    ${application}    ${modified_app1}
    Application Details Page
    Verification Info Pop-up
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    SSN Change for Co-Applicant Drop
    Prove Data
    Basic Information
    Personal Information
    SSN Re-Kyc Screen
    Handle Initial Flow
    Wait Until Element Is Visible    xpath:(//p)[1]    120
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    Co-App
    Personal Information    Co-App
    SSN Re-Kyc Screen    Co-App
    Handle Initial Flow

*** Keywords ***
Generate Phone Number Starting With 888
    ${random_part}=    Evaluate    ''.join(__import__('random').choices('0123456789', k=7))
    ${phone_number}=    Catenate    SEPARATOR=    ${START_DIGITS}    ${random_part}
    [Return]    ${phone_number}
SSN Changing for co-app
    # --- Generate Dynamic Values ---
    # First digit (1-5) and Last digit (1-9) for Applicant
    ${app_first}=     Evaluate    ''.join(__import__('random').choices('12345', k=1))
    ${app_last}=      Evaluate    ''.join(__import__('random').choices('123456789', k=1))
    ${app_ssn}=       Catenate    SEPARATOR=    ${app_first}    0010211    ${app_last}

    # First digit (1-5) and Last digit (1-9) for Co-Applicant
    ${co_first}=      Evaluate    ''.join(__import__('random').choices('12345', k=1))
    ${co_last}=       Evaluate    ''.join(__import__('random').choices('123456789', k=1))
    ${co_ssn}=        Catenate    SEPARATOR=    ${co_first}    0010211    ${co_last}

    # --- Apply to Dictionaries ---
    # Update Applicant SSN and Phone
    Set To Dictionary    ${application}    ssn=${app_ssn}

    # Update Co-App SSN and Phone
    Set To Dictionary    ${co_app_dup}     ssn=${co_ssn}

    # --- Log results ---
    Log To Console    Applicant SSN: ${app_ssn} | Co-App SSN: ${co_ssn}

    # Update Global Variables
    Set Global Variable    ${application}
    Set Global Variable    ${co_app_dup}

SSN Change for Applicant Drop
    ${last}=    Evaluate    "${application['ssn']}[-3:]"
    ${final_number1}=    Catenate    SEPARATOR=    500101    ${last}
    Log To Console    Final Number: ${final_number1}
    ${last3}=    Evaluate    "${application['ssn']}[-3:]"
    ${final_number2}=    Catenate    SEPARATOR=    500205    ${last3}
    Log To Console    Final Number: ${final_number2}
    ${modified_ssn1}=    Copy Dictionary    ${application}
    ${modified_ssn2}=    Copy Dictionary    ${co_app_dup}
    Set To Dictionary    ${modified_ssn2}    ssn=${final_number1}
    Set To Dictionary    ${modified_ssn1}    ssn=${final_number2}
    Set Global Variable    ${co_app_dup}    ${modified_ssn2}
    Set Global Variable    ${application}    ${modified_ssn1}

SSN Change for Co-Applicant Drop
    ${last}=    Evaluate    "${application['ssn']}[-3:]"
    ${final_number1}=    Catenate    SEPARATOR=    500205    ${last}
    Log To Console    Final Number: ${final_number1}
    ${last3}=    Evaluate    "${application['ssn']}[-3:]"
    ${final_number2}=    Catenate    SEPARATOR=    500101    ${last3}
    Log To Console    Final Number: ${final_number2}
    ${modified_ssn1}=    Copy Dictionary    ${application}
    ${modified_ssn2}=    Copy Dictionary    ${co_app_dup}
    Set To Dictionary    ${modified_ssn2}    ssn=${final_number1}
    Set To Dictionary    ${modified_ssn1}    ssn=${final_number2}
    Set Global Variable    ${co_app_dup}    ${modified_ssn2}
    Set Global Variable    ${application}    ${modified_ssn1}