*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot
Library         JSONLibrary  # Needed for parsing
Library         BuiltIn
*** Variables ***
${PCU_DATA}    ${CURDIR}/../../InputData/PCU_TestData.json
${INSTANCE}    rba4

*** Test Cases ***
PCU HappyCase
    [Tags]    ${INSTANCE}    R412007
    Load Lender Data    ${PCU_DATA}
    Merchant Portal Login    aditya.chelluru+12@finmkt.io    Qa@12345
    Merchant Selection Page    RbA-AD1  
    selecting the merchant location   RbA-AD1_Master 
    Sending Application to Consumer
    Dc plans page    9000    100    
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
    Set To Dictionary    ${modified_app}    email=satya.satti@finmkt.io
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
    Address Re-Kyc Screen
    Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div/div[2]/div/div/div/div/div/span/form/div[2]/div/div/button
    Handle Initial Flow