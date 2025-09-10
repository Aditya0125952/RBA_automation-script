*** Settings ***
Library    SeleniumLibrary
Library    PandasLibrary
Library    ExcelLibrary
Library    String
Library    Collections

*** Variables ***
${EXCEL_FILE}    C:/Users/AdityaChelluru/PycharmProjects/Test/InputData/answers.xlsx
${SheetName}     Sheet1
${answer}        aditya
${tech_issue}    Sorry, we are facing a technical issue with one of our data providers.

*** Keywords ***

Handle Initial Flow
    ${is_CoApp}=    Run Keyword And Return Status    Should Contain    ${TEST TAGS}    Co-App
    WHILE    True
        ${is_tech_issue}=    Run Keyword And Return Status    Page Should Contain Element    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/button
        ${is_identity}=      Run Keyword And Return Status    Page Should Contain    We need to verify your identity.
        Run Keyword If    ${is_tech_issue}    Handle Technical Issue Page
        Run Keyword If    ${is_identity}      Run Keywords    Handle Identity Verification Page    ${is_CoApp}    AND    Exit For Loop
        Sleep    2s
    END

Handle Technical Issue Page
    Wait Until Element Is Not Visible    css:div.position-absolute.bg-white.rounded-lg    20
    ${error_status}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/button    30
    WHILE    ${error_status}
        Wait Until Element Is Enabled    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/button    20
        Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/button
        Wait Until Element Is Not Visible    css:div.position-absolute.bg-white.rounded-lg    20
        ${error_status}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/button    20
    END

Handle Identity Verification Page
    [Arguments]    ${type}
    Wait Until Page Contains    We need to verify your identity.    120
    ${is_opened}=    Run Keyword And Return Status    Get Workbook    ${SheetName}
    IF    not ${is_opened}
        Open Excel Document    ${EXCEL_FILE}    ${SheetName}
    END
    ${q1}=    Get Text    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div/div[2]/div[1]/div/h3
    ${q2}=    Get Text    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div/div[2]/div[2]/div/h3
    ${q3}=    Get Text    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div/div[2]/div[3]/div/h3

    ${questions}=    Create List    ${q1}    ${q2}    ${q3}
    ${answers}=      Create List

    FOR    ${question}    IN    @{questions}
        ${found}=    Set Variable    False
        ${row}=      Set Variable    2
        WHILE    not ${found}
            ${data}=    Read Excel Cell    ${row}    2    ${SheetName}
            Run Keyword If    '${data}' == ''    Exit For Loop
            ${data_clean}=    Evaluate    '''${data}'''.strip()
            ${question_clean}=    Evaluate    '''${question}'''.strip()
            IF    '${data_clean}' == '${question_clean}'
                ${found}=    Set Variable    True
                ${answer}=    Read Excel Cell    ${row}    3    ${SheetName}
                Append To List    ${answers}    ${answer}
            END
            ${row}=    Evaluate    ${row} + 1
        END
        Run Keyword If    not ${found}    Log Question And Page URL    ${question}
    END

    Selecting Answers    ${answers}
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/span/form/div/div[3]/div/div/div/div/button
    Sleep    2s

    ${max_retry}=    Set Variable    10
    FOR    ${i}    IN RANGE    ${max_retry}
        ${tech_issue_again}=    Run Keyword And Return Status    Page Should Contain Element    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div/div[2]/div/div/button
        Run Keyword If    ${tech_issue_again}    Handle Technical Issue Page
        ${identity_still}=    Run Keyword And Return Status    Page Should Contain    We need to verify your identity.
        Exit For Loop If    not ${tech_issue_again} and not ${identity_still}
        Sleep    2s
    END
    ${is_pend}=    Run Keyword And Return Status    Should Contain    ${TEST TAGS}    Pend
    IF    not $is_pend and $type is None
        Wait Until Element Is Visible    xpath:/html/body/div/div[2]/div[1]/div/div[2]/div/div[2]/div/div/div/div/button    120
    ELSE
        # This block handles both Pend and Co-Applicant scenarios
        Close Current Excel Document
        ${location}=    Get Location
        ${Loan_ID}=    Loan ID Extraction    ${location}
        Log To Console    Extracted Loan ID = ${Loan_ID}
        RETURN
    END

Selecting Answers
    [Arguments]    ${answers}
    ${len}=    Get Length    ${answers}
    Run Keyword Unless    ${len} == 3    Fail    Expected 3 answers, but got ${len}

    ${ans1}=    Get From List    ${answers}    0
    ${ans2}=    Get From List    ${answers}    1
    ${ans3}=    Get From List    ${answers}    2

    Log To Console    Answer 1: ${ans1}
    Log To Console    Answer 2: ${ans2}
    Log To Console    Answer 3: ${ans3}

    # Question 1 - normal
    ${xpath1}=    Set Variable    xpath://h5[contains(text(), "${ans1}")]/preceding-sibling::input[@type="radio"]
    Click Element    ${xpath1}

    # Question 2 - special handling if 6'1"
    IF    "$ans2" == "6'1"
        Click Element    xpath=//input[@id="1_1" and @name="que2"]
    ELSE
        ${xpath2}=    Set Variable    xpath://h5[contains(text(), "${ans2}")]/preceding-sibling::input[@type="radio"]
        Click Element    ${xpath2}
    END
    # Question 3 - special handling if 6'1"
    IF    "$ans3" == "6'1"
        Click Element    xpath=//input[@id="1_1" and @name="que3"]
    ELSE
        ${xpath3}=    Set Variable    xpath://h5[contains(text(), "${ans3}")]/preceding-sibling::input[@type="radio"]
        Click Element    ${xpath3}
    END

    Sleep    2

Log Question And Page URL
    [Arguments]    ${question}
    ${current_url}=    Get Location
    Log To Console    \n[ERROR] Question not found: ${question}
    Log To Console    [DEBUG] Page URL when error occurred: ${current_url}


Loan ID Extraction
    [Arguments]    ${url}
    ${matches}=    Evaluate    __import__('re').findall(r'[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}', '''${url}''')
    Log To Console    DEBUG: Matches found: ${matches}

    # Return the first match if found, otherwise return None
    IF    $matches    # Check if list is not empty
        ${loan_id}=    Set Variable    ${matches[0]}
        RETURN    ${loan_id}
    ELSE
        RETURN    ${None}
    END
