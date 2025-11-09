*** Settings ***
Library    SeleniumLibrary
Library    Collections
Resource    ../common_Pages/common_Resoucres.robot
*** Keywords ***
Load and Prepare applicant details
    ${is_CoApp}=    Run Keyword And Return Status    Should Contain    ${TEST TAGS}    Co-App
    ${has_applicants}=    Evaluate    'Applicants' in ${LENDER_DATA}
    Log To Console    ${has_applicants}
    IF    '${has_applicants}' == 'True'
        IF    '${index1}' != 'None'
            ${application}=    Get From List    ${LENDER_DATA["Applicants"]}    ${index1}
        ELSE
            ${application}=    Get From Dictionary    ${LENDER_DATA}    Applicant
        END  
    ELSE
        ${application}=    Get From Dictionary    ${LENDER_DATA}    Applicant
    END
    IF    ${is_CoApp}
        IF    '${index2}' != 'None'
            ${co-app}=    Get From List    ${LENDER_DATA["Applicants"]}    ${index2}
            ${co_app_dup}=    Copy Dictionary    ${co-app}
            Set Global Variable    ${co_app_dup}
        ELSE
            ${co-app}=    Get From Dictionary    ${LENDER_DATA}    Co-Applicant
            ${co_app_dup}=    Copy Dictionary    ${co-app}
            Set Global Variable    ${co_app_dup}
        END
    END
    
    ${applicant}=    Copy Dictionary    ${application}
    Set Global Variable    ${applicant}
    Set Global Variable    ${application}