# Automation Testing Project

A web UI automation framework built with **Robot Framework**, **Python**, and **Selenium**. It follows the Page Object Model (POM) pattern for maintainability and includes custom Python libraries for utility functions and AI-assisted test enhancements.

---

## Tech Stack

| Tool | Purpose |
|---|---|
| Python 3.10+ | Core language |
| Robot Framework | Test execution and reporting |
| SeleniumLibrary | Web UI automation |
| Selenium WebDriver | Browser driver management |
| Custom Libraries | Reusable utilities and AI helpers |

---

## Project Structure

```
automation-project/
├── tests/
│   ├── web/                    # Feature-specific test suites
│   │   ├── login.robot
│   │   ├── search.robot
│   │   └── checkout.robot
│   └── smoke/                  # Smoke/sanity test suite
│       └── smoke_tests.robot
├── resources/
│   ├── keywords/               # Reusable keyword definitions
│   │   ├── common_keywords.robot
│   │   └── page_keywords.robot
│   ├── variables/              # Environment and test data variables
│   │   └── variables.robot
│   └── locators/               # Element locators per page
│       └── locators.robot
├── libraries/                  # Custom Python libraries
│   ├── ai_helper.py            # AI-assisted utilities (e.g. dynamic test data)
│   └── custom_utils.py         # General-purpose helpers
├── pages/                      # Page Object Model classes
│   ├── base_page.py
│   ├── login_page.py
│   └── search_page.py
├── results/                    # Test output, logs, and reports (auto-generated)
├── requirements.txt
├── robot.yaml
└── README.md
```

---

## Prerequisites

- Python 3.10 or higher
- Google Chrome (or Firefox) installed
- `pip` available in your environment

---

## Setup

**1. Clone the repository**

```bash
git clone <your-repo-url>
cd automation-project
```

**2. Create and activate a virtual environment**

```bash
python -m venv venv

# Windows
venv\Scripts\activate

# macOS/Linux
source venv/bin/activate
```

**3. Install dependencies**

```bash
pip install -r requirements.txt
```

**4. Install the browser driver**

The framework uses `webdriver-manager` to handle driver installation automatically. No manual driver download needed.

---

## Running Tests

**Run all tests**

```bash
robot --outputdir results tests/
```

**Run a specific suite**

```bash
robot --outputdir results tests/web/login.robot
```

**Run smoke tests only**

```bash
robot --outputdir results tests/smoke/
```

**Run by tag**

```bash
robot --outputdir results --include smoke tests/
```

**Run headless (no browser UI)**

```bash
robot --outputdir results --variable HEADLESS:true tests/
```

---

## Viewing Results

After execution, open the generated report in your browser:

```
results/report.html   ← Human-readable test report
results/log.html      ← Detailed execution log
results/output.xml    ← Raw output (CI/CD integration)
```

---

## Custom Libraries

| Library | Description |
|---|---|
| `libraries/custom_utils.py` | Helpers for data generation, file handling, and assertions |
| `libraries/ai_helper.py` | AI-assisted utilities such as dynamic test data generation and smart wait strategies |

To use them in a `.robot` file:

```robot
Library    ../../libraries/custom_utils.py
Library    ../../libraries/ai_helper.py
```

---

## Key Design Decisions

- **Page Object Model** — each page has its own Python class under `pages/`, separating locator logic from test logic.
- **Keyword abstraction** — common actions are wrapped in reusable Robot Framework keywords under `resources/keywords/`.
- **Centralized locators** — all element selectors live in `resources/locators/` so UI changes require edits in one place only.
- **Variable files** — environment URLs, credentials, and test data are stored in `resources/variables/` and can be overridden at runtime via `--variable`.

---

## requirements.txt

```
robotframework==7.0
robotframework-seleniumlibrary==6.3.0
selenium==4.21.0
webdriver-manager==4.0.1
openai==1.30.0
Faker==25.0.0
```
