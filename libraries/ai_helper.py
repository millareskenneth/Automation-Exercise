"""
ai_helper.py
------------
AI-assisted helper library for Robot Framework.
Uses the OpenAI API to generate dynamic test data and
produce human-readable summaries of test results.

Setup:
    Set the OPENAI_API_KEY environment variable before running tests.
    export OPENAI_API_KEY="sk-..."
"""

import os
from robot.api.deco import keyword
from robot.api import logger


class ai_helper:
    """AI-powered keywords for dynamic test data generation and result summarisation."""

    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    ROBOT_LIBRARY_DOC_FORMAT = "reST"

    def __init__(self):
        self._client = None

    def _get_client(self):
        """Lazy-load the OpenAI client so missing keys only fail if the keyword is called."""
        if self._client is None:
            try:
                from openai import OpenAI
                api_key = os.environ.get("OPENAI_API_KEY")
                if not api_key:
                    raise EnvironmentError(
                        "OPENAI_API_KEY environment variable is not set. "
                        "AI keywords will not work without it."
                    )
                self._client = OpenAI(api_key=api_key)
            except ImportError:
                raise ImportError(
                    "openai package is not installed. Run: pip install openai"
                )
        return self._client

    def _chat(self, prompt: str, max_tokens: int = 100) -> str:
        """Send a prompt to GPT and return the response text."""
        client = self._get_client()
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role": "user", "content": prompt}],
            max_tokens=max_tokens,
            temperature=0.7,
        )
        return response.choices[0].message.content.strip()

    # ------------------------------------------------------------------
    # Test data generation
    # ------------------------------------------------------------------

    @keyword("Generate AI Test User Info")
    def generate_ai_test_user_info(self) -> dict:
        """Ask the AI to generate a realistic checkout user profile.

        Returns a dictionary with keys: first_name, last_name, zip_code.

        Example:
        | &{user}= | Generate AI Test User Info |
        | Log | ${user.first_name} ${user.last_name} - ${user.zip_code} |
        """
        prompt = (
            "Generate a realistic fake US user profile for software testing. "
            "Reply ONLY in this exact format with no extra text:\n"
            "first_name: <value>\nlast_name: <value>\nzip_code: <value>"
        )
        raw = self._chat(prompt)
        logger.info(f"AI generated user info:\n{raw}")

        result = {}
        for line in raw.splitlines():
            if ":" in line:
                key, _, value = line.partition(":")
                result[key.strip()] = value.strip()
        return result

    @keyword("Generate AI Test Scenario Description")
    def generate_ai_test_scenario_description(self, scenario: str) -> str:
        """Ask the AI to write a one-line plain-English description for a test scenario.

        Example:
        | ${desc}= | Generate AI Test Scenario Description | login with locked out user |
        | Log | ${desc} |
        """
        prompt = (
            f"Write a single plain-English sentence describing this automated test scenario "
            f"for a QA report: '{scenario}'. Be concise and clear."
        )
        description = self._chat(prompt, max_tokens=60)
        logger.info(f"AI scenario description: {description}")
        return description

    # ------------------------------------------------------------------
    # Result summarisation
    # ------------------------------------------------------------------

    @keyword("Summarise Test Results With AI")
    def summarise_test_results_with_ai(self, passed: int, failed: int, total: int) -> str:
        """Ask the AI to produce a short plain-English test run summary.

        Example:
        | ${summary}= | Summarise Test Results With AI | 8 | 2 | 10 |
        | Log | ${summary} |
        """
        prompt = (
            f"A test suite ran {total} tests: {passed} passed, {failed} failed. "
            "Write a concise two-sentence QA summary suitable for a team report."
        )
        summary = self._chat(prompt, max_tokens=80)
        logger.info(f"AI test summary: {summary}")
        return summary
