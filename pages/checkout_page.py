from selenium.webdriver.common.by import By
from pages.base_page import BasePage


class CheckoutPage(BasePage):
    """Page object for the checkout flow (step one and step two)."""

    # Step one locators
    FIRST_NAME = (By.ID, "first-name")
    LAST_NAME = (By.ID, "last-name")
    ZIP_CODE = (By.ID, "postal-code")
    CONTINUE_BTN = (By.ID, "continue")
    ERROR_MSG = (By.CSS_SELECTOR, "[data-test='error']")

    # Step two locators
    FINISH_BTN = (By.ID, "finish")
    SUMMARY_TOTAL = (By.CLASS_NAME, "summary_total_label")

    # Confirmation
    CONFIRMATION_HEADER = (By.CLASS_NAME, "complete-header")

    def fill_customer_info(self, first_name, last_name, zip_code):
        self.type(self.FIRST_NAME, first_name)
        self.type(self.LAST_NAME, last_name)
        self.type(self.ZIP_CODE, zip_code)
        self.click(self.CONTINUE_BTN)

    def get_order_total(self):
        return self.get_text(self.SUMMARY_TOTAL)

    def finish_order(self):
        self.click(self.FINISH_BTN)

    def get_confirmation_message(self):
        return self.get_text(self.CONFIRMATION_HEADER)

    def is_error_displayed(self):
        return self.is_visible(self.ERROR_MSG)

    def get_error_message(self):
        return self.get_text(self.ERROR_MSG)
