*** Settings ***
Resource    resources/browser.resource
Test Teardown    Close All Browsers

*** Variables ***
${EXPECTED_TITLE}    Web form

*** Test Cases ***
# Goal: open Selenium's web form and verify its exact page title.
The Web Form Opens
    [Documentation]    Open the web form and check its title (Step 3.2).
    Open Lab Browser    https://www.selenium.dev/selenium/web/web-form.html
    Title Should Be    ${EXPECTED_TITLE}
