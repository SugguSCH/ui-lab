*** Settings ***
Documentation    QP-01: A custom pizza reaches the admin list.
Resource    resources/quickpizza.resource
Library    DateTime
Test Teardown    Close All Browsers

*** Test Cases ***
# Goal: restrictions are kept, anonymous rating needs login, and admin sees the same pizza/tool.
QP-01 A Custom Pizza Reaches The Admin List
    [Documentation]    Automate all seven steps of the written QP-01 in one browser.
    # Step 1: open QuickPizza.
    Open QuickPizza
    # Step 2: show the advanced fields.
    Turn On Advanced
    # Step 3: fill and check the restrictions and a unique name.
    ${stamp}=    Get Current Date    result_format=%Y%m%d-%H%M%S
    ${name}=    Set Variable    Lab Pizza ${stamp}
    Fill In The Pizza Request    600    Knife    ${name}
    Capture Page Screenshot    qp01-step3-fields.png
    # Step 4: request and check name, tool and calories.
    Ask For A Pizza
    ${tool}    ${calories}=    Recommendation Should Keep The Restrictions    ${name}    Knife    600
    Capture Element Screenshot    ${RECOMMENDATIONS}    qp01-step4-pizza.png
    # Step 5: rating without login must show the login message.
    Rate The Pizza Without Logging In
    Capture Page Screenshot    qp01-step5-login-needed.png
    # Step 6: sign in using the public practice site's provided account.
    Log In As Admin    admin    admin
    # Step 7: compare the admin row with the recommendation.
    Admin List Should Show The Pizza    ${name}    ${tool}
    Capture Page Screenshot    qp01-step7-admin-list.png
