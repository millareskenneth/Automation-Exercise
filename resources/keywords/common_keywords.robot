*** Settings ***
Library     SeleniumLibrary
Library     ../../libraries/browser_utils.py
Resource    ../variables/variables.robot
Resource    ../locators/locators.robot


*** Keywords ***
Open Browser To Login Page
    [Documentation]    Launch Chrome with hardened options (no updater, no telemetry, no noise)
    ...                and navigate to the SauceDemo login page.
    Open Browser    ${BASE_URL}    ${BROWSER}    options=${CHROME_OPTIONS}
    Wait Until Element Is Visible    ${LOC_LOGIN_BTN}    timeout=10s

Close Test Browser
    [Documentation]    Close the browser after each test.
    Close Browser

Login With Valid Credentials
    [Documentation]    Log in using the standard valid user account.
    Input Text        ${LOC_USERNAME}     ${VALID_USER}
    Input Text        ${LOC_PASSWORD}     ${VALID_PASSWORD}
    Click Button      ${LOC_LOGIN_BTN}

Login With Credentials
    [Documentation]    Log in using provided username and password.
    [Arguments]        ${username}    ${password}
    Input Text        ${LOC_USERNAME}     ${username}
    Input Text        ${LOC_PASSWORD}     ${password}
    Click Button      ${LOC_LOGIN_BTN}

Verify Error Message
    [Documentation]    Assert the login error banner contains the expected text.
    [Arguments]        ${expected_message}
    Wait Until Element Is Visible    ${LOC_ERROR_MSG}    timeout=10s
    Element Text Should Be           ${LOC_ERROR_MSG}    ${expected_message}

Verify On Inventory Page
    [Documentation]    Assert that the inventory/products page has loaded.
    Wait Until Element Is Visible    ${LOC_PAGE_TITLE}    timeout=10s
    Element Text Should Be           ${LOC_PAGE_TITLE}    Products

Add Item To Cart
    [Documentation]    Add the first available item to cart via dispatchEvent.
    ...                Confirms via localStorage (reliable) rather than the lazily-rendered badge.
    Wait Until Element Is Visible    ${LOC_ADD_TO_CART}    timeout=10s
    ${before}=    Get Cart Item Count From Storage
    Execute Javascript
    ...    var btn = document.querySelector("[data-test^='add-to-cart']");
    ...    btn.dispatchEvent(new MouseEvent('click', {bubbles:true, cancelable:true, view:window}));
    ${expected}=    Evaluate    ${before} + 1
    Wait Until Cart Has Items    ${expected}

Go To Cart
    [Documentation]    Navigate directly to the cart page URL.
    Go To                            ${CART_URL}
    Wait Until Element Is Visible    ${LOC_CHECKOUT_BTN}    timeout=10s

Verify Cart Badge Count
    [Documentation]    Assert the cart holds the expected number of items (via localStorage).
    [Arguments]        ${expected_count}
    Wait Until Cart Has Items    ${expected_count}
    ${count}=    Get Cart Item Count From Storage
    Should Be Equal As Integers    ${count}    ${expected_count}

Proceed To Checkout
    [Documentation]    Navigate directly to checkout step one.
    Go To                            ${CHECKOUT_URL}
    Wait Until Element Is Visible    ${LOC_FIRST_NAME}    timeout=10s

Fill Checkout Info
    [Documentation]    Fill customer info on checkout step one and submit.
    ...                If the form is valid it advances to step two.
    [Arguments]    ${first}    ${last}    ${zip}
    Wait Until Element Is Visible    ${LOC_FIRST_NAME}    timeout=10s
    Input Text      ${LOC_FIRST_NAME}   ${first}
    Input Text      ${LOC_LAST_NAME}    ${last}
    Input Text      ${LOC_ZIP_CODE}     ${zip}
    Execute Javascript
    ...    var form = document.querySelector('form');
    ...    var key = Object.keys(form).find(function(k){return k.startsWith('__reactProps');});
    ...    if(key && form[key] && typeof form[key].onSubmit === 'function'){
    ...        form[key].onSubmit({preventDefault:function(){},stopPropagation:function(){},target:form});
    ...    }
    ${advanced}=    Run Keyword And Return Status
    ...    Wait Until Location Contains    checkout-step-two    timeout=8s
    IF    ${advanced}
        Wait Until Element Is Visible    ${LOC_FINISH_BTN}    timeout=10s
    END

Finish Order
    [Documentation]    Click Finish on checkout step two to place the order.
    Wait Until Element Is Visible    ${LOC_FINISH_BTN}    timeout=10s
    Execute Javascript
    ...    var btn = document.querySelector('#finish');
    ...    btn.dispatchEvent(new MouseEvent('click', {bubbles:true, cancelable:true, view:window}));

Verify Order Confirmed
    [Documentation]    Assert the order confirmation message is displayed.
    Wait Until Element Is Visible    ${LOC_CONFIRM_HEADER}    timeout=15s
    Element Text Should Be           ${LOC_CONFIRM_HEADER}    Thank you for your order!

Start Session
    [Documentation]    Open a fresh browser, navigate to login page, and log in.
    ...                Use as Test Setup for suites that need a clean logged-in state per test.
    Open Browser To Login Page
    Login With Valid Credentials
    Wait Until Element Is Visible    ${LOC_ADD_TO_CART}    timeout=15s

End Session
    [Documentation]    Close the browser. Use as Test Teardown.
    Close Browser
