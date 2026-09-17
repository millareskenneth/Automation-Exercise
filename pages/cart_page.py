from selenium.webdriver.common.by import By
from pages.base_page import BasePage


class CartPage(BasePage):
    """Page object for the shopping cart page."""

    # Locators
    CART_ITEMS = (By.CLASS_NAME, "cart_item")
    CHECKOUT_BTN = (By.ID, "checkout")
    CONTINUE_SHOPPING_BTN = (By.ID, "continue-shopping")
    ITEM_NAMES = (By.CLASS_NAME, "inventory_item_name")

    def get_cart_item_count(self):
        return len(self.driver.find_elements(*self.CART_ITEMS))

    def get_item_names(self):
        return [el.text for el in self.driver.find_elements(*self.ITEM_NAMES)]

    def proceed_to_checkout(self):
        self.click(self.CHECKOUT_BTN)
