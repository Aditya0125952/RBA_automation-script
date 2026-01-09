*** Settings ***
Library    SeleniumLibrary
Resource    ../../common_pages/common_Resoucres.robot
Library         JSONLibrary  # Needed for parsing
Library         BuiltIn
*** Variables ***
${FFC_DATA}    ${CURDIR}/../../InputData/FF_TestData.json
${INSTANCE}    rba

*** Test Cases ***
FFC HappyCase
    [Tags]    ${INSTANCE}    S100617        
    ${test_data}=    Get Test Data  
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login         
    Merchant Selection Page    Sunlight_HI   
    Selecting The Merchant Location    Sunlight_HI_Master   
    Sending Application to Consumer
    Dc plans page   
    Type of Application page
    Load and Prepare applicant details
    ${modified_app}=    Copy Dictionary    ${application}
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


FFC Counter_Offer
    [Tags]    ${INSTANCE}
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

FFC Pending Review
    [Tags]    ${INSTANCE}    R418006    
    Load Lender Data    ${FFC_DATA}
    Merchant Portal Login
    Merchant Selection Page    Sunlight_HI
    #Selecting The Merchant Location   
    Sending Application to Consumer
    Dc plans page    1000001    0
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



*** Keywords ***
Get Test Data
    [Documentation]
    ...    This keyword smartly loads test data.
    ...    If run from run.py, it parses the ${DYNAMIC_TEST_DATA} variable.
    ...    If run manually (e.g., from VS Code), it loads from ${FFC_DATA_FILE}.
    
    # 1. Check if the variable from run.py exists
    ${script_run_detected}=    Run Keyword And Return Status    Variable Should Exist    ${DYNAMIC_TEST_DATA}
    
    # 2. Use the modern IF/ELSE structure
    IF    ${script_run_detected}
        Log    Automatic run detected. Parsing dynamic data.
        ${data}=    Parse Json    ${DYNAMIC_TEST_DATA}
    ELSE
        Log    Manual run detected. Loading default file.
        ${data}=    Load Json From File    ${FFC_DATA}
    END
    
    # 3. Return the final data object
    # This uses the modern RETURN statement, which fixes the [Return] deprecation warning
    RETURN    ${data}