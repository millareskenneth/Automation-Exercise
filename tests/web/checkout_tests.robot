*** Settings ***
Documentation       Test suite for SauceDemo end-to-end checkout flow.
...                 Covers happy path completion and empty field edge cases.

Library             SeleniumLibrary
Library             ../../libraries/custom_utils.py
Resource            ../../resources/keywords/common_keywords.robot
Resource            ../../resources/variables/variables.robot
Resource            ../../resources/locators/locators.robot

Suite Setup         Run Keywords    Open Browser To Login Page    AND    Login With Valid Credentials
Suite Teardown      Close Test Browser
Test Setup          Go To    ${INVENTORY_URL}


*** Test Cases ***
Complete Checkout With Valid Info
    [Documentation]    Full end-to-end flow: add item → cart → checkout → confirm order.
    [Tags]    smoke    checkout    e2e
    Add Item To Cart
    Go To Cart
    Proceed To Checkout
    Fill Checkout Info    ${FIRST_NAME}    ${LAST_NAME}    ${ZIP_CODE}
    Finish Order
    Verify Order Confirmed

Complete Checkout With Random User Data
    [Documentation]    Same e2e flow using Faker-generated customer info.
    [Tags]    checkout    e2e
    ${first}=    Generate Random First Name
    ${last}=     Generate Random Last Name
    ${zip}=      Generate Random Zip Code
    Add Item To Cart
    Go To Cart
    Proceed To Checkout
    Fill Checkout Info    ${first}    ${last}    ${zip}
    Finish Order
    Verify Order Confirmed

Checkout Fails Without First Name
    [Documentation]    Submitting checkout step one with no first name should show an error.
    [Tags]    checkout    negative    edge-case
    Add Item To Cart
    Go To Cart
    Proceed To Checkout
    Fill Checkout Info    ${EMPTY}    ${LAST_NAME}    ${ZIP_CODE}
    Element Should Be Visible    ${LOC_ERROR_MSG}

Checkout Fails Without Last Name
    [Documentation]    Submitting checkout step one with no last name should show an error.
    [Tags]    checkout    negative    edge-case
    Add Item To Cart
    Go To Cart
    Proceed To Checkout
    Fill Checkout Info    ${FIRST_NAME}    ${EMPTY}    ${ZIP_CODE}
    Element Should Be Visible    ${LOC_ERROR_MSG}

Checkout Fails Without Zip Code
    [Documentation]    Submitting checkout step one with no zip code should show an error.
    [Tags]    checkout    negative    edge-case
    Add Item To Cart
    Go To Cart
    Proceed To Checkout
    Fill Checkout Info    ${FIRST_NAME}    ${LAST_NAME}    ${EMPTY}
    Element Should Be Visible    ${LOC_ERROR_MSG}
