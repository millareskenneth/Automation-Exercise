*** Settings ***
Documentation       Test suite for SauceDemo cart page.
...                 Covers item presence in cart and navigation to checkout.

Library             SeleniumLibrary
Resource            ../../resources/keywords/common_keywords.robot
Resource            ../../resources/variables/variables.robot
Resource            ../../resources/locators/locators.robot

Suite Setup         Run Keywords    Open Browser To Login Page    AND    Login With Valid Credentials
Suite Teardown      Close Test Browser
Test Setup          Go To    ${INVENTORY_URL}


*** Test Cases ***
Cart Contains Added Item
    [Documentation]    An item added on the inventory page should appear in the cart.
    [Tags]    smoke    cart
    Add Item To Cart
    Go To Cart
    ${count}=    Get Element Count    ${LOC_CART_ITEM}
    Should Be Equal As Integers    ${count}    1

Cart Shows Correct Item Count After Adding Two Items
    [Documentation]    Two items added should result in two cart rows.
    [Tags]    cart
    Add Item To Cart
    Add Item To Cart
    Go To Cart
    ${count}=    Get Element Count    ${LOC_CART_ITEM}
    Should Be Equal As Integers    ${count}    2

Checkout Button Navigates To Checkout Page
    [Documentation]    Clicking Checkout from a non-empty cart should load the checkout form.
    [Tags]    smoke    cart    checkout
    Add Item To Cart
    Go To Cart
    Proceed To Checkout
    Element Should Be Visible    ${LOC_FIRST_NAME}
