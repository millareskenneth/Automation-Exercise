*** Settings ***
Documentation       Smoke test suite — fast sanity checks across core flows.
...                 Run this suite first to confirm the environment is healthy.

Library             SeleniumLibrary
Resource            ../../resources/keywords/common_keywords.robot
Resource            ../../resources/variables/variables.robot
Resource            ../../resources/locators/locators.robot

Suite Setup         Open Browser To Login Page
Suite Teardown      Close Test Browser


*** Test Cases ***
Smoke - Login Page Is Accessible
    [Documentation]    Verify the SauceDemo login page loads and the login button is present.
    [Tags]    smoke
    Element Should Be Visible    ${LOC_LOGIN_BTN}

Smoke - Valid Login Works
    [Documentation]    Standard user can log in and reach the inventory page.
    [Tags]    smoke
    Login With Valid Credentials
    Verify On Inventory Page

Smoke - Add Item And Verify Cart Badge
    [Documentation]    Adding one item shows badge count 1.
    [Tags]    smoke
    Add Item To Cart
    Verify Cart Badge Count    1

Smoke - Full Checkout Flow
    [Documentation]    End-to-end: add item → cart → checkout → order confirmed.
    [Tags]    smoke
    Add Item To Cart
    Go To Cart
    Proceed To Checkout
    Fill Checkout Info    John    Doe    12345
    Finish Order
    Verify Order Confirmed
