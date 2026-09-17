"""
custom_utils.py
---------------
General-purpose helper library for Robot Framework.
Provides reusable utilities for test data generation,
string/number helpers, and common assertions.
"""

from faker import Faker
from robot.api.deco import keyword
from robot.api import logger

_fake = Faker()


class custom_utils:
    """Custom utility keywords available to all Robot Framework test suites."""

    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    ROBOT_LIBRARY_DOC_FORMAT = "reST"

    # ------------------------------------------------------------------
    # Test data generation
    # ------------------------------------------------------------------

    @keyword("Generate Random Full Name")
    def generate_random_full_name(self) -> str:
        """Return a randomly generated full name using Faker.

        Example:
        | ${name}= | Generate Random Full Name |
        """
        name = _fake.name()
        logger.info(f"Generated name: {name}")
        return name

    @keyword("Generate Random First Name")
    def generate_random_first_name(self) -> str:
        """Return a randomly generated first name."""
        return _fake.first_name()

    @keyword("Generate Random Last Name")
    def generate_random_last_name(self) -> str:
        """Return a randomly generated last name."""
        return _fake.last_name()

    @keyword("Generate Random Zip Code")
    def generate_random_zip_code(self) -> str:
        """Return a randomly generated US zip code.

        Example:
        | ${zip}= | Generate Random Zip Code |
        """
        return _fake.zipcode()

    @keyword("Generate Random Email")
    def generate_random_email(self) -> str:
        """Return a randomly generated email address."""
        return _fake.email()

    # ------------------------------------------------------------------
    # String helpers
    # ------------------------------------------------------------------

    @keyword("String Should Contain")
    def string_should_contain(self, text: str, substring: str) -> None:
        """Fail if *substring* is not found inside *text*.

        Example:
        | String Should Contain | Thank you for your order! | Thank you |
        """
        assert substring in text, f"Expected '{substring}' to be in '{text}'"

    @keyword("Normalize Whitespace")
    def normalize_whitespace(self, text: str) -> str:
        """Strip and collapse multiple spaces in *text* to a single space."""
        return " ".join(text.split())

    # ------------------------------------------------------------------
    # Number helpers
    # ------------------------------------------------------------------

    @keyword("Parse Price To Float")
    def parse_price_to_float(self, price_str: str) -> float:
        """Strip currency symbols and return a float value.

        Example:
        | ${total}= | Parse Price To Float | $29.99 |
        | Should Be Equal As Numbers | ${total} | 29.99 |
        """
        cleaned = price_str.replace("$", "").replace(",", "").strip()
        return float(cleaned)
