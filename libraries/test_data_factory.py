"""Keywords that generate disposable test data, so scenarios never depend on fixed values."""

import secrets
import uuid

from robot.api.deco import keyword, library


@library(scope="GLOBAL")
class TestDataFactory:
    # Prevents pytest-style collectors from treating this class as a test.
    __test__ = False

    @staticmethod
    def _suffix() -> str:
        return uuid.uuid4().hex[:8]

    @keyword("Gerar Credenciais Inválidas")
    def invalid_credentials(self) -> dict[str, str]:
        """Returns a username and password that do not exist in the application."""
        suffix = self._suffix()
        return {"username": f"usuario_invalido_{suffix}", "password": f"senha_invalida_{suffix}"}

    @keyword("Gerar Dados Do Comprador")
    def customer(self, **overrides: str) -> dict[str, str]:
        """Returns buyer data for the checkout form.

        Any field can be replaced, e.g. ``Gerar Dados Do Comprador    first_name=${EMPTY}``.
        """
        data = {
            "first_name": f"Cliente {self._suffix()}",
            "last_name": "Teste",
            "postal_code": str(secrets.randbelow(90_000_000) + 10_000_000),
        }
        unknown = set(overrides) - set(data)
        if unknown:
            raise ValueError(
                f"Campos desconhecidos para o comprador: {', '.join(sorted(unknown))}."
            )
        data.update(overrides)
        return data

    @keyword("Gerar Dados Do Comprador Sem O Campo")
    def customer_without(self, field: str) -> dict[str, str]:
        """Returns buyer data with ``field`` (first_name, last_name or postal_code) left empty."""
        return self.customer(**{field: ""})
