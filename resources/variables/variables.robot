*** Variables ***
# Base URL
${BASE_URL}         https://www.saucedemo.com
${INVENTORY_URL}    https://www.saucedemo.com/inventory.html
${CART_URL}         https://www.saucedemo.com/cart.html
${CHECKOUT_URL}     https://www.saucedemo.com/checkout-step-one.html

# Browser config
${BROWSER}          chrome
${HEADLESS}         false
${SELENIUM_SPEED}   0.5s

# Chrome options string (SeleniumLibrary parses this into ChromeOptions).
# Suppresses the Chrome updater, telemetry, sync, notifications and console noise
# that otherwise spawns extra/blank windows and floods the log.
${CHROME_OPTIONS}   add_argument("--window-size=1600,1000"); add_argument("--disable-notifications"); add_argument("--disable-component-update"); add_argument("--disable-background-networking"); add_argument("--disable-sync"); add_argument("--no-first-run"); add_argument("--no-default-browser-check"); add_argument("--disable-gpu"); add_argument("--log-level=3"); add_experimental_option("excludeSwitches", ["enable-logging"])

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
