*** Settings ***
Library    SeleniumLibrary
Library    JSONLibrary
Resource    ../common_Pages/common_Resoucres.robot

*** Variables ***
@{KNOWN_PLANS}
...    S100617    S100617-AUT    S100617-PP-AUT    S100617-UG-AUT
...    S101217    S101817    S102417
...    Z303600    Z303600-TD-AUT    Z302400    Z304800    Z306000    Z307200
...    R424008    R418009    R418007    R418005    R418006    R418008    R418013    R418015
...    R412005    R412007    R412009    R412013    R412002    R412003    R412004    R412004-DIV-AUT    R412006
...    R424007    R424005    R424009    R424006    R424004
...    H30300    H201205    H201209
...    F193728
...    GICU_RBA
...    Dividend    Dividend_Plan    Dividend Test
...    PowerPay2 Test    PowerPay2 CoApp
...    Upgrade

*** Keywords ***
Dc plans page
    [Arguments]    ${amount}=None    ${deposite}=None
    FOR    ${tag}    IN    @{TEST_TAGS}
        ${is_present}=    Run Keyword And Return Status    List Should Contain Value    ${KNOWN_PLANS}    ${tag}
        IF    ${is_present}
            ${Lender}=    Copy Dictionary    ${LENDER_DATA}
            Set To Dictionary    ${Lender}    planID=${tag}
            Set Global Variable    ${LENDER_DATA}    ${Lender}
        END
    END
    Wait Until Element Is Not Visible        css:div.position-absolute.bg-white    10
    Wait Until Element Is Visible    xpath:/html/body/div/div[2]/div[1]/div/div/div[2]/div/span/form/span/div/div[1]/div/div[1]/h4/b    20
    Wait Until Element Is Enabled    ${LENDER_DATA['planID']}       
    Click Button   ${LENDER_DATA['planID']}
    IF    '${amount}' == 'None'
        Input Text    enter-project-cost    ${LENDER_DATA['projectCost']}
        Input Text    enter-deposit-amount    ${LENDER_DATA['depositAmount']}
    ELSE
        Input Text    enter-project-cost    ${amount}
        Input Text    enter-deposit-amount    ${deposite}
    END
    Click Button    xpath:/html/body/div/div[2]/div[1]/div/div/div[2]/div/span/form/span/div/div[2]/div[2]/div/div/div[1]/div/button