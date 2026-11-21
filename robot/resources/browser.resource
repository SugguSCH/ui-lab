*** Settings ***
Library    SeleniumLibrary    timeout=10s

*** Variables ***
${BROWSER}    chrome

*** Keywords ***
Open Lab Browser
    [Arguments]    ${url}
    Open Browser    ${url}    ${BROWSER}
    ...    service=executable_path=r'%{CHROMEDRIVER}'
    Set Window Size    1280    1600
