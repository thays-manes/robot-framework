"""Robot Framework variable file with the environment configuration.

Values are resolved with this precedence (highest first):
1. ``--variable NAME:value`` on the command line (handled by Robot Framework itself);
2. operating system environment variables;
3. the ``.env`` file in the project root;
4. the defaults below.

The environment is selected with ``TEST_ENV`` (``demo``, ``dev``, ``qa``, ``hml`` or ``prod``).
"""

import os
from pathlib import Path

from dotenv import load_dotenv

PROJECT_ROOT = Path(__file__).resolve().parent.parent

# override=False keeps real environment variables (e.g. CI secrets) above the .env file.
load_dotenv(PROJECT_ROOT / ".env", override=False)

# "demo" points to Sauce Demo, a public application built for test automation practice.
ENVIRONMENTS: dict[str, dict[str, object]] = {
    "demo": {
        "url_var": "BASE_URL",
        "default_url": "https://www.saucedemo.com",
        "production": False,
    },
    "dev": {"url_var": "BASE_URL_DEV", "default_url": None, "production": False},
    "qa": {"url_var": "BASE_URL_QA", "default_url": None, "production": False},
    "hml": {"url_var": "BASE_URL_HML", "default_url": None, "production": False},
    "prod": {"url_var": "BASE_URL_PROD", "default_url": None, "production": True},
}

TRUE_VALUES = {"1", "true", "yes", "sim", "on"}
FALSE_VALUES = {"0", "false", "no", "nao", "não", "off"}


def _to_bool(value: str | None, default: bool) -> bool:
    if value is None or not value.strip():
        return default
    normalized = value.strip().lower()
    if normalized in TRUE_VALUES:
        return True
    if normalized in FALSE_VALUES:
        return False
    raise ValueError(f"Valor booleano inválido: '{value}'. Use true ou false.")


def get_variables(environment: str = "") -> dict[str, object]:
    """Returns the variables exposed to Robot Framework for the selected environment."""
    name = (environment or os.getenv("TEST_ENV") or "demo").strip().lower()
    if name not in ENVIRONMENTS:
        raise ValueError(
            f"TEST_ENV inválido: '{name}'. Valores aceitos: {', '.join(ENVIRONMENTS)}."
        )

    settings = ENVIRONMENTS[name]
    url_var = str(settings["url_var"])
    base_url = os.getenv(url_var) or settings["default_url"]
    if not base_url:
        raise ValueError(f"Defina a variável {url_var} no .env para executar no ambiente '{name}'.")

    return {
        "ENVIRONMENT": name,
        "BASE_URL": str(base_url).rstrip("/"),
        "IS_PRODUCTION": bool(settings["production"]),
        "BROWSER": os.getenv("BROWSER", "chromium"),
        "HEADLESS": _to_bool(os.getenv("HEADLESS"), default=True),
        "TIMEOUT": os.getenv("TIMEOUT", "10s"),
        "VIEWPORT": {"width": 1366, "height": 768},
    }
