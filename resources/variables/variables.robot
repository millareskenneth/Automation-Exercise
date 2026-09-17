*** Variables ***
# Base URL
${BASE_URL}         https://www.saucedemo.com
${INVENTORY_URL}    https://www.saucedemo.com/inventory.html

# Browser config
${BROWSER}          chrome
${HEADLESS}         false

# Valid credentials
${VALID_USER}       standard_user
${VALID_PASSWORD}   secret_sauce

# Invalid credentials
${INVALID_USER}         invalid_user
${INVALID_PASSWORD}     wrong_password

# Locked out user
${LOCKED_USER}      locked_out_user

# Checkout info
${FIRST_NAME}       John
${LAST_NAME}        Doe
${ZIP_CODE}         12345

# Expected messages
${ERROR_LOCKED}     Epic sadface: Sorry, this user has been locked out.
${ERROR_INVALID}    Epic sadface: Username and password do not match any user in this service
${ERROR_EMPTY_USER}     Epic sadface: Username is required
${ERROR_EMPTY_PASS}     Epic sadface: Password is required
${CONFIRM_MSG}      Thank you for your order!
