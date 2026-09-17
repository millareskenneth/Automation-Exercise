from selenium.webdriver.common.by import By
from pages.base_page import BasePage


class InventoryPage(BasePage):
    """Page object for the products/inventory page."""

    # Locators
    PAGE_TITLE = (By.CLASS_NAME, "title")
    PRODUCT_ITEMS = (By.CLASS_NAME, "inventory_item")
    ADD_TO_CART_BTN = (By.CSS_SELECTOR, "[data-test^='add-to-cart']")
    CART_BADGE = (By.CLASS_NAME, "shopping_cart_badge")
    CART_ICON = (By.CLASS_NAME, "shopping_cart_link")
    SORT_DROPDOWN = (By.CLASS_NAME, "product_sort_container")

    def get_page_title(self):
        return self.get_text(self.PAGE_TITLE)

    def add_first_item_to_cart(self):
        buttons = self.driver.find_elements(*self.ADD_TO_CART_BTN)
        if buttons:
            buttons[0].click()

    def add_item_to_cart_by_index(self, index=0):
        buttons = self.driver.find_elements(*self.ADD_TO_CART_BTN)
        buttons[index].click()

    def get_cart_count(self):
        try:
            return self.get_text(self.CART_BADGE)
        except Exception:
            return "0"

    def go_to_cart(self):
        self.click(self.CART_ICON)

    def get_product_count(self):
        return len(self.driver.find_elements(*self.PRODUCT_ITEMS))
