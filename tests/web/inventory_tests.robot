*** Settings ***
Documentation       Test suite for SauceDemo inventory/products page.
...                 Covers page load, product count, and add-to-cart badge update.

Library             SeleniumLibrary
Resource            ../../resources/keywords/common_keywords.robot
Resource            ../../resources/variables/variables.robot
Resource            ../../resources/locators/locators.robot

Suite Setup         Run Keywords    Open Browser To Login Page    AND    Login With Valid Credentials
Suite Teardown      Close Test Browser
Test Setup          Reset App State


*** Test Cases ***
Inventory Page Loads With Correct Title
    [Documentation]    After login the page title should read 'Products'.
    [Tags]    smoke    inventory
    Verify On Inventory Page

Inventory Page Displays Six Products
    [Documentation]    SauceDemo always shows exactly 6 products on the inventory page.
    [Tags]    inventory
    ${count}=    Get Element Count    class:inventory_item
    Should Be Equal As Integers    ${count}    6

Add To Cart Updates Badge Count
    [Documentation]    Adding one item should show a badge count of 1 on the cart icon.
    [Tags]    smoke    inventory    cart
    Add Item To Cart
    Verify Cart Badge Count    1

Add Multiple Items Updates Badge Count
    [Documentation]    Adding two items should reflect count 2 on the cart badge.
    [Tags]    inventory    cart
    Add Item To Cart
    Add Item To Cart
    Verify Cart Badge Count    2
