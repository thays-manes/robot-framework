"""Keywords to read credentials from environment variables.

User profiles live in ``data/users.json`` and only reference the *names* of the
environment variables that hold the real values, so no secret is versioned.
"""

import json
import os
from pathlib import Path

from robot.api.deco import keyword, library

PROJECT_ROOT = Path(__file__).resolve().parent.parent
USERS_FILE = PROJECT_ROOT / "data" / "users.json"


@library(scope="GLOBAL")
class EnvironmentLibrary:
    def __init__(self) -> None:
        # Make sure the .env file is loaded even if this library is imported on its own.
        from dotenv import load_dotenv

        load_dotenv(PROJECT_ROOT / ".env", override=False)
        self._profiles = self._load_profiles()

    @staticmethod
    def _load_profiles() -> dict[str, dict[str, str]]:
        try:
            with USERS_FILE.open(encoding="utf-8") as file:
                return json.load(file)
        except FileNotFoundError as error:
            raise RuntimeError(f"Arquivo de usuários não encontrado: {USERS_FILE}") from error
        except json.JSONDecodeError as error:
            raise RuntimeError(f"Arquivo de usuários inválido ({USERS_FILE}): {error}") from error

    def _profile(self, profile: str) -> dict[str, str]:
        if profile not in self._profiles:
            available = ", ".join(self._profiles)
            raise ValueError(f"Perfil de usuário '{profile}' não existe. Disponíveis: {available}.")
        return self._profiles[profile]

    @keyword("Obter Variável De Ambiente Obrigatória")
    def get_required_env(self, name: str) -> str:
        """Returns the value of ``name`` or fails with a clear message when it is not set."""
        value = os.getenv(name, "").strip()
        if not value:
            raise RuntimeError(
                f"Variável de ambiente obrigatória '{name}' não definida. "
                "Copie .env.example para .env e preencha os valores."
            )
        return value

    @keyword("Usuário Está Configurado")
    def is_user_configured(self, profile: str) -> bool:
        """Returns ``True`` when every environment variable of the profile has a value."""
        data = self._profile(profile)
        return all(os.getenv(data[key], "").strip() for key in ("username_env", "password_env"))

    @keyword("Obter Credenciais Do Usuário")
    def get_user_credentials(self, profile: str) -> dict[str, str]:
        """Returns ``{'username': ..., 'password': ...}`` for a profile of ``data/users.json``."""
        data = self._profile(profile)
        return {
            "username": self.get_required_env(data["username_env"]),
            "password": self.get_required_env(data["password_env"]),
        }
