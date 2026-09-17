*** Settings ***
Documentation       Test suite for SauceDemo login functionality.
...                 Covers valid login, invalid credentials, locked user, and empty field edge cases.

Library             SeleniumLibrary
Library             ../../libraries/custom_utils.py
Resource            ../../resources/keywords/common_keywords.robot
Resource            ../../resources/variables/variables.robot
Resource            ../../resources/locators/locators.robot

Suite Setup         Open Browser To Login Page
Suite Teardown      Close Test Browser


*** Test Cases ***
Valid Login Redirects To Inventory Page
    [Documentation]    A valid user should land on the Products page after login.
    [Tags]    smoke    login    positive
    Login With Valid Credentials
    Verify On Inventory Page

Invalid Credentials Shows Error Message
    [Documentation]    Wrong username/password should display an inline error banner.
    [Tags]    login    negative
    Login With Credentials    ${INVALID_USER}    ${INVALID_PASSWORD}
    Verify Error Message    ${ERROR_INVALID}

Locked Out User Shows Error Message
    [Documentation]    A locked-out user should see the appropriate error message.
    [Tags]    login    negative
    Login With Credentials    ${LOCKED_USER}    ${VALID_PASSWORD}
    Verify Error Message    ${ERROR_LOCKED}

Empty Username Shows Error Message
    [Documentation]    Submitting with no username should show a validation error.
    [Tags]    login    negative    edge-case
    Login With Credentials    ${EMPTY}    ${VALID_PASSWORD}
    Verify Error Message    ${ERROR_EMPTY_USER}

Empty Password Shows Error Message
    [Documentation]    Submitting with no password should show a validation error.
    [Tags]    login    negative    edge-case
    Login With Credentials    ${VALID_USER}    ${EMPTY}
    Verify Error Message    ${ERROR_EMPTY_PASS}
