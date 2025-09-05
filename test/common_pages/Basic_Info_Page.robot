*** Settings ***
Library    SeleniumLibrary
Library    JSONLibrary
Resource    ../common_Pages/common_Resoucres.robot

*** Keywords ***
basic information
    [Arguments]    ${primary}=None
    ${is_CoApp}=    Run Keyword And Return Status    Should Contain    ${TEST TAGS}    Co-App
    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div/div[7]/div/div/span/div/input    30
    Sleep    3
    ${is_prove}=    Run Keyword And Return Status    Should Contain    ${TEST TAGS}    Prove
    IF    '${primary}'=='None'
        ${data}=       Set Variable    ${application}
    ELSE
        ${data}=       Set Variable If    ${is_CoApp}    ${co_app_dup}    ${application}
    END
    IF    ${is_prove}
        Handle Prove Scenario    ${is_CoApp}    ${data}
    ELSE
        Handle NonProve Scenario    ${is_CoApp}    ${primary}    ${data}
    END

Handle Prove Scenario
    [Arguments]    ${type}    ${data}

    # Handle dropdown selections
    Execute JavaScript    document.getElementById("INSTALLATION__ADDRESS__DROPDOWN").value = "true";
    Execute JavaScript    document.getElementById("INSTALLATION__ADDRESS__DROPDOWN").dispatchEvent(new Event('change'));
    Sleep    2
    Select From List By Label    INSTALLATION__ADDRESS__DROPDOWN    ${data['Do_you_own_installation_add']}

    Execute JavaScript    document.getElementById("INSTALLATION__ADDRESS__RESIDE__DROPDOWN").value = "true";
    Execute JavaScript    document.getElementById("INSTALLATION__ADDRESS__RESIDE__DROPDOWN").dispatchEvent(new Event('change'));
    Sleep    2
    Select From List By Label    INSTALLATION__ADDRESS__RESIDE__DROPDOWN    ${data['Do_you_reside_installation_add']}

    # For Prove case, handle co-applicant address if needed
    IF    ${type}
        Fill Billing Address    ${data}
    END

    Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div/div[14]/div/div/button

Handle NonProve Scenario
    [Arguments]    ${is_CoApp}    ${primary}    ${data}

    # Handle date of birth input
    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div/div[7]/div/div/span/div/input    10
    Input Text    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div/div[7]/div/div/span/div/input    ${data['dob']}

    # Handle dropdown selections
    Wait Until Element Is Enabled    INSTALLATION__ADDRESS__DROPDOWN
    Execute JavaScript    document.getElementById("INSTALLATION__ADDRESS__DROPDOWN").value = "true";
    Execute JavaScript    document.getElementById("INSTALLATION__ADDRESS__DROPDOWN").dispatchEvent(new Event('change'));
    Sleep    2
    Select From List By Label    INSTALLATION__ADDRESS__DROPDOWN    ${application['Do_you_own_installation_add']}
    Execute JavaScript    document.getElementById("INSTALLATION__ADDRESS__RESIDE__DROPDOWN").value = "true";
    Execute JavaScript    document.getElementById("INSTALLATION__ADDRESS__RESIDE__DROPDOWN").dispatchEvent(new Event('change'));
    Sleep    2
    Select From List By Label    INSTALLATION__ADDRESS__RESIDE__DROPDOWN    ${application['Do_you_reside_installation_add']}
    # Handle address section
    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div/div[12]/div/span/div/div/label/span[2]    20

    IF    '${primary}' == '${None}'
        Click Element    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div/div[12]/div/span/div/div/label/span[2]
    ELSE
        # If this is a co-applicant (an applicant value exists), fill in their specific billing address.
        Fill Billing Address    ${data}
    END

    Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div/div[14]/div/div/button

Fill Billing Address
    [Arguments]    ${data}

    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div/fieldset[2]/div[4]/div/span/div/input    120
    Input Text    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div/fieldset[2]/div[4]/div/span/div/input    ${data['city']}
    Sleep    1

    Wait Until Element Is Enabled    billing-address-1-md    120
    Input Text    billing-address-1-md    ${data['street_add']}
    Sleep    1

    Select From List By Label    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div/fieldset[2]/div[7]/div[1]/span/div/select    ${data['state']}

    Wait Until Element Is Enabled    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div/fieldset[2]/div[7]/div[2]/span/div/input    120
    Sleep    1
    Input Text    xpath:/html/body/div[1]/div[2]/div[1]/div/div/div[2]/span/form/fieldset/div/fieldset[2]/div[7]/div[2]/span/div/input    ${data['zipcode']}