*** Settings ***
Library     SeleniumLibrary
Library     ../../libraries/custom_utils.py
Resource    ../variables/variables.robot
Resource    ../locators/locators.robot


*** Keywords ***
Open Browser To Login Page
    [Documentation]    Launch browser and navigate to the SauceDemo login page.
    ${browser_name}=    Set Variable If    '${HEADLESS}' == 'true' or '${HEADLESS}' == 'True'    headlesschrome    ${BROWSER}
    Open Browser    ${BASE_URL}    ${browser_name}
    Maximize Browser Window
    Set Selenium Speed    ${SELENIUM_SPEED}

Close Test Browser
    [Documentation]    Close the browser after each test.
    Close Browser

Login With Valid Credentials
    [Documentation]    Log in using the standard valid user account.
    Login With Credentials    ${VALID_USER}    ${VALID_PASSWORD}

Login With Credentials
    [Documentation]    Log in using provided username and password.
    [Arguments]        ${username}    ${password}
    Wait Until Element Is Visible    ${LOC_USERNAME}     timeout=10s
    Set React Input Value            ${LOC_USERNAME}     ${username}
    Set React Input Value            ${LOC_PASSWORD}     ${password}
    Click Element JS                 ${LOC_LOGIN_BTN}

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
    [Documentation]    Click the first available Add to Cart button.
    Wait Until Element Is Visible    ${LOC_ADD_TO_CART}    timeout=10s
    Click Element JS                 ${LOC_ADD_TO_CART}

Go To Cart
    [Documentation]    Click the cart icon to navigate to the cart page.
    Wait Until Element Is Visible    ${LOC_CART_ICON}    timeout=10s
    Click Element JS                 ${LOC_CART_ICON}

Verify Cart Badge Count
    [Documentation]    Assert the cart badge shows the expected item count.
    [Arguments]        ${expected_count}
    Wait Until Element Is Visible    ${LOC_CART_BADGE}    timeout=10s
    Element Text Should Be           ${LOC_CART_BADGE}    ${expected_count}

Proceed To Checkout
    [Documentation]    Click the Checkout button on the cart page.
    Wait Until Element Is Visible    ${LOC_CHECKOUT_BTN}    timeout=10s
    Click Element JS                 ${LOC_CHECKOUT_BTN}

Fill Checkout Info
    [Documentation]    Fill in customer info on checkout step one.
    [Arguments]    ${first}    ${last}    ${zip}
    Wait Until Element Is Visible    ${LOC_FIRST_NAME}    timeout=10s
    Set React Input Value    ${LOC_FIRST_NAME}   ${first}
    Set React Input Value    ${LOC_LAST_NAME}    ${last}
    Set React Input Value    ${LOC_ZIP_CODE}     ${zip}
    Click Element JS         ${LOC_CONTINUE_BTN}

Finish Order
    [Documentation]    Click Finish on checkout step two to place the order.
    Wait Until Element Is Visible    ${LOC_FINISH_BTN}    timeout=10s
    Click Element JS                 ${LOC_FINISH_BTN}

Verify Order Confirmed
    [Documentation]    Assert the order confirmation message is displayed.
    Wait Until Element Is Visible    ${LOC_CONFIRM_HEADER}    timeout=15s
    Element Text Should Be           ${LOC_CONFIRM_HEADER}    Thank you for your order!

Reset App State
    [Documentation]    Clear SauceDemo cart and session state via localStorage, then reload inventory.
    ...                Use this as Test Setup when tests share a browser session.
    Execute Javascript               window.localStorage.clear()
    Go To                            ${INVENTORY_URL}
    ${is_login_page}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${LOC_LOGIN_BTN}
    IF    ${is_login_page}
        Login With Valid Credentials
    END
    Wait Until Element Is Visible    ${LOC_ADD_TO_CART}    timeout=15s
