*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot

*** Variables ***
${GICU_DATA}    ${CURDIR}/../../InputData/GICU_TestData.json
${instance}    rba

*** Test Cases ***
GICU Happycase
    [Tags]    R412007    ${instance}    Co-App
    Load Lender Data    ${GICU_DATA}
    Merchant Portal Login
    Merchant Selection Page
    Sending Application to Consumer
    Dc plans page    10000    5000
    Type of Application page
    Load and Prepare applicant details
    ${modified_app1}=    Copy Dictionary    ${application}
    ${modified_app2}=    Copy Dictionary    ${co_app_dup}
     Set To Dictionary    ${modified_app1}    email=bhavanasri.challamalla@finmkt.io
     Set To Dictionary    ${modified_app2}    email=bhavanasri.challamalla@finmkt.io
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
    Address Re-Kyc Screen
    Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button
    Handle Initial Flow
    Wait Until Element Is Visible    xpath:(//p)[1]    120
    URL Applicant
    Application Authorization Page
    Credit Freeze Page
    Prove Data
    Basic Information    Co-App
    Personal Information    Co-App
    Sleep    5
    Handle Initial Flow