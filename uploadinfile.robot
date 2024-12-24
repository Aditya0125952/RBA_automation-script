*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${UploadFiletest}           css=[type='file']
${AddFile}          C:/Users/AdityaChelluru/PycharmProjects/testing/TestCases/resource/DL.jpg

*** Test Cases ***
Test for Upload
    Open Browser      https://imagetopdf.com/    Chrome
    Upload file

*** Keywords ***
Upload file
    Wait Until Page Contains Element   ${UploadFiletest}   60
    Scroll Element Into View     ${UploadFiletest}
    Choose File     ${UploadFiletest}     ${AddFile}
    sleep  5