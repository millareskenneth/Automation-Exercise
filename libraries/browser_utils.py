"""
browser_utils.py
----------------
Browser interaction helpers for Robot Framework that work reliably against
modern Chrome (v150+) and React single-page apps.

Why this exists:
    Recent Chrome versions stopped delivering Selenium's synthetic click events
    to React's synthetic event system for certain elements (submit inputs,
    react-router links). Standard `Click Element` / `Click Button` reach the DOM
    but React never runs its onClick/onSubmit handler, so nothing happens.

    The fix is to dispatch a *trusted* mouse event through the Chrome DevTools
    Protocol (CDP) `Input.dispatchMouseEvent`. React treats these exactly like a
    real user click, so navigation, add-to-cart, and form submits all work.

Usage in Robot Framework:
    Library    ../../libraries/browser_utils.py

    CDP Click    css:[data-test^='add-to-cart']
    CDP Click    id:checkout
"""

import time

from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn


class browser_utils:
    """Trusted-click helpers backed by the Chrome DevTools Protocol."""

    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    ROBOT_LIBRARY_DOC_FORMAT = "reST"

    def _driver(self):
        """Return the live Selenium WebDriver from the running SeleniumLibrary."""
        selib = BuiltIn().get_library_instance("SeleniumLibrary")
        return selib.driver

    def _resolve_element(self, driver, locator):
        """Resolve a Robot-style locator (e.g. 'id:foo', 'css:.bar') to a WebElement."""
        from selenium.webdriver.common.by import By

        strategies = {
            "id": By.ID,
            "css": By.CSS_SELECTOR,
            "xpath": By.XPATH,
            "name": By.NAME,
            "class": By.CLASS_NAME,
            "tag": By.TAG_NAME,
            "link": By.LINK_TEXT,
        }
        if ":" in locator:
            prefix, value = locator.split(":", 1)
            by = strategies.get(prefix.strip().lower())
            if by:
                return driver.find_element(by, value)
        # Default: treat as CSS selector
        return driver.find_element(By.CSS_SELECTOR, locator)

    @keyword("CDP Click")
    def cdp_click(self, locator: str) -> None:
        """Click an element using a trusted CDP mouse event.

        Scrolls the element to the centre of the viewport, then dispatches a
        trusted mouse-press/release sequence through the Chrome DevTools Protocol.
        Coordinates are scaled by the device pixel ratio so clicks land correctly
        on HiDPI / scaled displays.

        Example:
        | CDP Click | id:checkout |
        | CDP Click | css:[data-test^='add-to-cart'] |
        """
        driver = self._driver()
        element = self._resolve_element(driver, locator)

        driver.execute_script(
            "arguments[0].scrollIntoView({block:'center', inline:'center'});", element
        )
        time.sleep(0.2)

        # getBoundingClientRect gives CSS pixels; CDP needs physical pixels.
        data = driver.execute_script(
            """
            var r = arguments[0].getBoundingClientRect();
            return {
                cx: r.left + r.width / 2,
                cy: r.top + r.height / 2,
                dpr: window.devicePixelRatio || 1
            };
            """,
            element,
        )
        x = data["cx"] * data["dpr"]
        y = data["cy"] * data["dpr"]

        driver.execute_cdp_cmd(
            "Input.dispatchMouseEvent", {"type": "mouseMoved", "x": x, "y": y}
        )
        driver.execute_cdp_cmd(
            "Input.dispatchMouseEvent",
            {"type": "mousePressed", "x": x, "y": y, "button": "left", "clickCount": 1},
        )
        driver.execute_cdp_cmd(
            "Input.dispatchMouseEvent",
            {"type": "mouseReleased", "x": x, "y": y, "button": "left", "clickCount": 1},
        )
        logger.info(f"CDP click on '{locator}' at CSS ({data['cx']:.0f},{data['cy']:.0f}) "
                    f"→ physical ({x:.0f},{y:.0f}) DPR={data['dpr']}")

    @keyword("Get Cart Item Count From Storage")
    def get_cart_item_count_from_storage(self) -> int:
        """Return the number of items in the SauceDemo cart via localStorage.

        SauceDemo persists the cart to the ``cart-contents`` localStorage key as a
        JSON array of product ids. Reading it directly is far more reliable than
        waiting for the badge element, which renders lazily.

        Example:
        | ${count}= | Get Cart Item Count From Storage |
        | Should Be Equal As Integers | ${count} | 1 |
        """
        driver = self._driver()
        raw = driver.execute_script("return window.localStorage.getItem('cart-contents');")
        if not raw:
            return 0
        import json

        try:
            return len(json.loads(raw))
        except (ValueError, TypeError):
            return 0

    @keyword("Wait Until Cart Has Items")
    def wait_until_cart_has_items(self, expected_count: int = 1, timeout: float = 10.0) -> None:
        """Wait until the cart in localStorage holds *expected_count* items.

        Polls the ``cart-contents`` localStorage key until it reports the expected
        number of items or the timeout elapses.

        Example:
        | Wait Until Cart Has Items | 1 |
        """
        expected = int(expected_count)
        deadline = time.time() + float(timeout)
        last = 0
        while time.time() < deadline:
            last = self.get_cart_item_count_from_storage()
            if last >= expected:
                logger.info(f"Cart holds {last} item(s).")
                return
            time.sleep(0.25)
        raise AssertionError(
            f"Cart did not reach {expected} item(s) within {timeout}s (last saw {last})."
        )
