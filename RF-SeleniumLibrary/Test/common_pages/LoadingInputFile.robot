*** Settings ***
Library    SeleniumLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    Collections

*** Variables ***
${LENDER_DATA}         None
${APPLICANT_LIST}      None
${SELECTED_APPLICANT}  None

*** Keywords ***
Load Lender Data
    [Arguments]    ${file_path}    ${index1}=None    ${index2}=None
    ${json_text}=    Get File    ${file_path}
    ${data}=         Convert String To Json    ${json_text}
    Set Suite Variable    ${index1}    ${index1}
    Set Suite Variable    ${index2}    ${index2}
    Set Suite Variable    ${LENDER_DATA}    ${data}

