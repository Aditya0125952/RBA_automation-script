*** Settings ***
Library    SeleniumLibrary
Library    JSONLibrary
Resource    ../common_Pages/common_Resoucres.robot

*** Keywords ***
Personal information
    [Arguments]    ${primary}=None
    ${is_CoApp}=    Run Keyword And Return Status    Should Contain    ${TEST TAGS}    Co-App
    Wait Until Element Is Visible    xpath://button[contains(text(), 'Next') or contains(@type, 'submit')]    20s
    Sleep    2s

    ${is_prove}=    Run Keyword And Return Status    Should Contain    ${TEST TAGS}    Prove
    IF    '${primary}'=='None'
        ${data}=       Set Variable    ${application}
    ELSE
        ${data}=       Set Variable If    ${is_CoApp}    ${co_app_dup}    ${application}
    END
    Wait Until Element Is Not Visible    xpath=//div[contains(@style, 'backdrop-filter: blur')]    timeout=15s
    IF    ${is_prove}
        Fill Personal Information    ${data}    ${FALSE}
    ELSE
        Fill Personal Information    ${data}    ${TRUE}
    END

    Sleep    3
    Click Button    xpath://button[contains(text(), 'Next') or contains(@type, 'submit')]

Fill Personal Information
    [Arguments]    ${data}    ${include_ssn}=${FALSE}
    Wait Until Element Is Visible    xpath://button[contains(text(), 'Next') or contains(@type, 'submit')]    20s
    Sleep    2s
    Wait Until Element Is Visible    annual-income    20
    Wait Until Element Is Enabled    annual-income    10
    Input Text    annual-income    ${data['annual_income']}
    Input Text    household-income    ${data['household_income']}

    Select From List By Label    EMPLOYMENT__STATUS__DROPDOWN    ${data['employment_status']}
    Select From List By Label    CITIZENSHIP__STATUS__DROPDOWN    ${data['citizenship_status']}

    IF    '${data['employment_status']}' == 'Employed'
        Wait Until Element Is Visible    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div[1]/div[3]/span/div/input
        Input Text    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div[1]/div[3]/span/div/input    ${application['occupation']}
        Input Text    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div[1]/div[4]/span/div/input    ${application['employer_name']}
    END

    Input Text    monthly-mortgage    ${data['monthly_mortgage_amount']}

    IF    ${include_ssn}
        Input Text    ssn    ${data['ssn']}
    END