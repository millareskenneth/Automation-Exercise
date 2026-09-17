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
    Element Should Be Visible    ${LOC_ERROR_MSG}
    Element Text Should Be       ${LOC_ERROR_MSG}    ${expected_message}

Verify On Inventory Page
    [Documentation]    Assert that the inventory/products page has loaded.
    Element Text Should Be    ${LOC_PAGE_TITLE}    Products

Add Item To Cart
    [Documentation]    Click the first available Add to Cart button.
    Click Element     ${LOC_ADD_TO_CART}

Go To Cart
    [Documentation]    Click the cart icon to navigate to the cart page.
    Click Element     ${LOC_CART_ICON}

Verify Cart Badge Count
    [Documentation]    Assert the cart badge shows the expected item count.
    [Arguments]        ${expected_count}
    Element Text Should Be    ${LOC_CART_BADGE}    ${expected_count}

Proceed To Checkout
    [Documentation]    Click the Checkout button on the cart page.
    Click Button    ${LOC_CHECKOUT_BTN}

Fill Checkout Info
    [Documentation]    Fill in customer info on checkout step one.
    [Arguments]    ${first}    ${last}    ${zip}
    Input Text      ${LOC_FIRST_NAME}   ${first}
    Input Text      ${LOC_LAST_NAME}    ${last}
    Input Text      ${LOC_ZIP_CODE}     ${zip}
    Click Button    ${LOC_CONTINUE_BTN}

Finish Order
    [Documentation]    Click Finish on checkout step two to place the order.
    Click Button    ${LOC_FINISH_BTN}

Verify Order Confirmed
    [Documentation]    Assert the order confirmation message is displayed.
    Element Text Should Be    ${LOC_CONFIRM_HEADER}    Thank you for your order!

Reset App State
    [Documentation]    Clear SauceDemo cart and session state via localStorage, then reload inventory.
    ...                Use this as Test Setup when tests share a browser session.
    Execute Javascript    window.localStorage.clear()
    Go To                 ${INVENTORY_URL}
