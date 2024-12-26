*** Settings ***
Library           BuiltIn
Library           String

*** Variables ***
${HOST}         imap.your_mail_server.com
${PORT}         993  # Change to appropriate port for your mail server
${FOLDER}       INBOX
${USERNAME}     your_username
${PASSWORD}     your_password

*** Test Cases ***
Read Emails
    [Tags]  imap  read_emails
    ${connection}=    Create IMAP Connection    ${HOST}    ${PORT}    ${FOLDER}    ${USERNAME}    ${PASSWORD}
    ${result, data}=  Search Emails  ${connection}  'ALL'

    # Process emails (e.g., extract subject, sender, body)
    # ...
    Close IMAP Connection

*** Keywords ***
Create IMAP Connection
    [Arguments]  ${host}  ${port}  ${folder}  ${username}  ${password}
    Create Dictionary  credentials  username=${username}  password=${password}
    Create Instance  IMAP4_SSL  ${host}  ${port}  **kwargs:${credentials}
    Select Folder  ${folder}
    [Return]  ${self._imap}  # Assuming 'self' refers to the class instance

Close IMAP Connection
    [Arguments]  ${connection}
    Call Method  ${connection}  close  # Close the connection
    Call Method  ${connection}  logout  # Logout from the mailbox

Select Folder
    [Arguments]  ${folder}
    Call Method  ${self._imap}  select  ${folder}  # Select the specified folder

Search Emails
    [Arguments]  ${connection}  ${criteria}
    ${result, data}=  Run Keyword And Ignore Error  ${connection}.search  None  ${criteria}
    [Return]  ${result}  ${data}