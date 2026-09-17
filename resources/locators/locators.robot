*** Variables ***
# --- Login Page ---
${LOC_USERNAME}         id:user-name
${LOC_PASSWORD}         id:password
${LOC_LOGIN_BTN}        id:login-button
${LOC_ERROR_MSG}        css:[data-test='error']

# --- Inventory Page ---
${LOC_PAGE_TITLE}       class:title
${LOC_CART_BADGE}       class:shopping_cart_badge
${LOC_CART_ICON}        class:shopping_cart_link
${LOC_SORT_DROPDOWN}    class:product_sort_container
${LOC_ADD_TO_CART}      css:[data-test^='add-to-cart']

# --- Cart Page ---
${LOC_CART_ITEM}        class:cart_item
${LOC_CHECKOUT_BTN}     id:checkout
${LOC_ITEM_NAME}        class:inventory_item_name

# --- Checkout Step One ---
${LOC_FIRST_NAME}       id:first-name
${LOC_LAST_NAME}        id:last-name
${LOC_ZIP_CODE}         id:postal-code
${LOC_CONTINUE_BTN}     id:continue

# --- Checkout Step Two ---
${LOC_FINISH_BTN}       id:finish
${LOC_ORDER_TOTAL}      class:summary_total_label

# --- Confirmation ---
${LOC_CONFIRM_HEADER}   class:complete-header
