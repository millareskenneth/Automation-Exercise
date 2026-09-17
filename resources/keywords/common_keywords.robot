*** Settings ***
Library     SeleniumLibrary
Resource    ../variables/variables.robot
Resource    ../locators/locators.robot


*** Keywords ***
Open Browser To Login Page
    [Documentation]    Launch browser and navigate to the SauceDemo login page.
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window

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
    [Documentation]    Add the first available item to cart using a MouseEvent dispatch
    ...                to ensure React's synthetic event system is triggered correctly.
    Wait Until Element Is Visible    ${LOC_ADD_TO_CART}    timeout=10s
    Execute Javascript
    ...    var btn = document.querySelector("[data-test^='add-to-cart']");
    ...    btn.dispatchEvent(new MouseEvent('click', {bubbles:true, cancelable:true, view:window}));
    Wait Until Element Is Visible    ${LOC_CART_BADGE}    timeout=10s

Go To Cart
    [Documentation]    Navigate directly to the cart page URL.
    Go To                            ${CART_URL}
    Wait Until Element Is Visible    ${LOC_CHECKOUT_BTN}    timeout=10s

Verify Cart Badge Count
    [Documentation]    Assert the cart badge shows the expected item count.
    [Arguments]        ${expected_count}
    Wait Until Element Is Visible    ${LOC_CART_BADGE}    timeout=10s
    Element Text Should Be           ${LOC_CART_BADGE}    ${expected_count}

Proceed To Checkout
    [Documentation]    Navigate directly to checkout step one page.
    Go To                            ${CHECKOUT_URL}
    Wait Until Element Is Visible    ${LOC_FIRST_NAME}    timeout=10s

Fill Checkout Info
    [Documentation]    Fill in customer info on checkout step one.
    [Arguments]    ${first}    ${last}    ${zip}
    Wait Until Element Is Visible    ${LOC_FIRST_NAME}    timeout=10s
    Input Text      ${LOC_FIRST_NAME}   ${first}
    Input Text      ${LOC_LAST_NAME}    ${last}
    Input Text      ${LOC_ZIP_CODE}     ${zip}
    Execute Javascript
    ...    var btn = document.querySelector('#continue');
    ...    btn.dispatchEvent(new MouseEvent('click', {bubbles:true, cancelable:true, view:window}));

Finish Order
    [Documentation]    Click Finish on checkout step two using dispatchEvent for React compatibility.
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
    Sleep    0.5s

End Session
    [Documentation]    Close the browser. Use as Test Teardown.
    Close Browser
