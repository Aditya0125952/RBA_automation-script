*** Settings ***
Library    SeleniumLibrary

*** Test Cases ***
Payments
    #procees payments
    Wait Until Element Is Not Visible    css=div.position-absolute.bg-white.rounded-lg    20
    Wait Until Element Is Not Visible        css:div.position-absolute.bg-white    20
    Wait Until Element Is Visible    xpath:Wait Until Element Is Not Visible    css=div.position-absolute.bg-white.rounded-lg    20
    Wait Until Element Is Not Visible        css:div.position-absolute.bg-white    20
    Wait Until Element Is Visible    xpath://div[@class='col-md-12 d-flex justify-content-end']//div[@name='Send Application']//div//button[@type='submit'][normalize-space()='Send Application']    60
    Wait Until Element Is Enabled    xpath://div[@class='col-md-12 d-flex justify-content-end']//div[@name='Send Application']//div//button[@type='submit'][normalize-space()='Send Application']    30
    Wait Until Element Is Not Visible    css=div.position-absolute.bg-white.rounded-lg    20
    Click Button    xpath://div[@class='col-md-12 d-flex justify-content-end']//div[@name='Send Application']//div//button[@type='submit'][normalize-space()='Send Application']
    Switch Window    title:Point Of Sale    20    60
    Wait Until Element Is Enabled    xpath://div[@class='col-md-12 d-flex justify-content-end']//div[@name='Send Application']//div//button[@type='submit'][normalize-space()='Send Application']    30
    Wait Until Element Is Not Visible    css=div.position-absolute.bg-white.rounded-lg    20
    Click Button    xpath://div[@class='col-md-12 d-flex justify-content-end']//div[@name='Send Application']//div//button[@type='submit'][normalize-space()='Send Application']
    Switch Window    title:Point Of Sale    20