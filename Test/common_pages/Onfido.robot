*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${file_upload_xpath}    //*[@id="Document-root"]/div/div[3]/div[1]/div/input
${file_path}     C:/Users/AdityaChelluru/PycharmProjects/Test/InputData/front_dl.jpg
${url}     https://rba5-qa.mktplacegateway.com/c/pending-screen/consumer/documents?appId=58a0594f-0018-40ae-9df1-df16107b4860&type=APPLICANT&m=677ce4d3c54eaa67cc6729e6&locationId=65003947c54eaa49aabf904f&loanId=64b601e6-a234-4560-b250-1739eb418ab1
*** Keywords ***
Onfido Page
    Wait Until Element Is Visible    onfido-sdk    20
    Wait Until Keyword Succeeds    15s    500ms
    ...    Select Frame    xpath://iframe[@name='onfido-welcome']
    Wait Until Element Is Visible    xpath://*[@id="Welcome-root"]/div/div[3]/div[1]/button    20    
    Wait Until Element Is Enabled    xpath://*[@id="Welcome-root"]/div/div[3]/div[1]/button    20
    Click Button    xpath://*[@id="Welcome-root"]/div/div[3]/div[1]/button
    Unselect Frame
    Wait Until Keyword Succeeds    15    500   
    ...    Select Frame    xpath://*[@id="onfido-sdk"]/iframe[1]
    Wait Until Element Is Visible    xpath://*[@id="Document-root"]/div/div[2]/div/form/div[4]/fieldset/ul/li[1]/button    20
    Wait Until Element Is Enabled    xpath://*[@id="Document-root"]/div/div[2]/div/form/div[4]/fieldset/ul/li[1]/button    20
    Click Button    xpath://*[@id="Document-root"]/div/div[2]/div/form/div[4]/fieldset/ul/li[1]/button
    Unselect Frame
    Wait Until Keyword Succeeds    15    500
    ...    Select Frame    xpath://*[@id="onfido-sdk"]/iframe[1]
    Choose File    xpath:${file_upload_xpath}    ${file_path}
    Wait Until Element Is Visible    xpath://*[@id="Document-root"]/div/div[3]/div[1]/button[2]    20
    Wait Until Element Is Enabled    xpath://*[@id="Document-root"]/div/div[3]/div[1]/button[2]    20
    Click Button    xpath://*[@id="Document-root"]/div/div[3]/div[1]/button[2]
    Unselect Frame
    Wait Until Keyword Succeeds    15    500
    ...    Select Frame    xpath://*[@id="onfido-sdk"]/iframe[1]
    Wait Until Element Is Visible    xpath://*[@id="Document-root"]/div/div[3]/div[1]/div/div/button    20
    Choose File    xpath:${file_upload_xpath}    ${file_path}
    Wait Until Element Is Visible    xpath://*[@id="Document-root"]/div/div[3]/div[1]/button[2]    20
    Wait Until Element Is Enabled    xpath://*[@id="Document-root"]/div/div[3]/div[1]/button[2]    20
    Click Button    xpath://*[@id="Document-root"]/div/div[3]/div[1]/button[2]
    Unselect Frame
    Wait Until Element Is Visible    xpath:/html/body/div/div[2]/div[1]/div[2]/div/div/h3    20
    Sleep    3
