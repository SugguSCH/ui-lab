*** Settings ***
Documentation    QuickPizza page locators and reusable QP-01 keywords.
Resource    browser.resource
Library    String

*** Variables ***
${URL}    https://quickpizza.grafana.com
${HEADING}    Looking to break out of your pizza routine?
${ADVANCED}    xpath://label[.//span[normalize-space()='Advanced']]
${MAX CALORIES}    xpath://label[normalize-space()='Max Calories per Slice']/preceding-sibling::input
${EXCLUDED TOOLS}    css:select
${VEGETARIAN}    id:default-checkbox
${PIZZA NAME}    css:input#pizza-name
${REQUEST BUTTON}    name:pizza-please
${RECOMMENDATIONS}    id:recommendations
${TOOL LINE}    xpath://p[starts-with(.,'Tool:')]
${CALORIES LINE}    xpath://p[starts-with(.,'Calories per slice:')]
${RATE BUTTON}    name:rate-5
${RATE RESULT}    id:rate-result
${READY}    id:svelte-announcer
${USERNAME}    id:username
${ADMIN PASSWORD FIELD}    id:password
${SIGN IN}    css:button[type=submit]

*** Keywords ***
Open QuickPizza
    [Documentation]    QP-01 step 1: a fresh browser, no login.
    Open Lab Browser    ${URL}
    Wait Until Element Is Visible    css:h1
    Element Text Should Be    css:h1    ${HEADING}

Turn On Advanced
    [Documentation]    QP-01 step 2: expose all four fields and wait for tools to load.
    Click Element    ${ADVANCED}
    Wait Until Page Contains Element    xpath://option[normalize-space()='Knife']
    Element Should Be Visible    ${MAX CALORIES}
    Element Should Be Visible    ${EXCLUDED TOOLS}
    Element Should Be Visible    ${VEGETARIAN}
    Element Should Be Visible    ${PIZZA NAME}

Fill In The Pizza Request
    [Documentation]    QP-01 step 3: fill and verify each requested value.
    [Arguments]    ${calories}    ${tool}    ${name}
    Input Text    ${MAX CALORIES}    ${calories}
    Select From List By Label    ${EXCLUDED TOOLS}    ${tool}
    Select Checkbox    ${VEGETARIAN}
    Input Text    ${PIZZA NAME}    ${name}
    Textfield Value Should Be    ${MAX CALORIES}    ${calories}
    List Selection Should Be    ${EXCLUDED TOOLS}    ${tool}
    Checkbox Should Be Selected    ${VEGETARIAN}
    Textfield Value Should Be    ${PIZZA NAME}    ${name}

Ask For A Pizza
    [Documentation]    QP-01 step 4: wait for a real recommendation, without fixed sleeps.
    Click Button    ${REQUEST BUTTON}
    Wait Until Element Contains    ${RECOMMENDATIONS}    Name:

Recommendation Should Keep The Restrictions
    [Arguments]    ${name}    ${excluded tool}    ${max calories}
    Element Should Contain    ${RECOMMENDATIONS}    Name: ${name}
    ${line}=    Get Text    ${TOOL LINE}
    ${tool}=    Remove String    ${line}    Tool:${SPACE}
    Should Not Be Empty    ${tool}
    Should Not Be Equal    ${tool}    ${excluded tool}
    ${line}=    Get Text    ${CALORIES LINE}
    ${calories}=    Remove String    ${line}    Calories per slice:${SPACE}
    ${calories}=    Convert To Integer    ${calories}
    Should Be True    0 <= ${calories} <= ${max calories}
    Log    Recommendation: name=${name}; tool=${tool}; calories=${calories}
    RETURN    ${tool}    ${calories}

Rate The Pizza Without Logging In
    [Documentation]    QP-01 step 5: anonymous rating is rejected.
    Click Button    ${RATE BUTTON}
    Wait Until Element Contains    ${RATE RESULT}    Please log in first.
    Element Text Should Be    ${RATE RESULT}    Please log in first.

Log In As Admin
    [Documentation]    QP-01 step 6: keep the browser's server affinity cookie.
    [Arguments]    ${user}    ${password}
    Go To    ${URL}/admin
    Wait Until Page Contains Element    ${READY}
    Input Text    ${USERNAME}    ${user}
    Input Password    ${ADMIN PASSWORD FIELD}    ${password}
    Click Button    ${SIGN IN}
    Wait Until Page Contains    Latest pizza recommendations

Admin List Should Show The Pizza
    [Documentation]    QP-01 step 7: search all rows and compare with step 4's tool.
    [Arguments]    ${name}    ${tool}
    ${row}=    Set Variable    xpath://li[contains(.,'${name}')]
    Wait Until Element Is Visible    ${row}
    Element Should Contain    ${row}    (tool=${tool},
    ${text}=    Get Text    ${row}
    Log    Admin row: ${text}
