"""Keywords for monetary values. Uses Decimal to avoid floating point errors when summing prices."""

import re
from decimal import ROUND_HALF_UP, Decimal

from robot.api.deco import keyword, library

PRICE_PATTERN = re.compile(r"\$\s*(\d+(?:\.\d+)?)")
CENTS = Decimal("0.01")


@library(scope="GLOBAL")
class PriceLibrary:
    @keyword("Converter Texto Em Preço")
    def parse_price(self, text: str) -> Decimal:
        """Extracts the value from labels such as ``$29.99`` or ``Total: $43.18``."""
        match = PRICE_PATTERN.search(text)
        if not match:
            raise ValueError(f"Não foi possível extrair um valor monetário de '{text}'.")
        return Decimal(match.group(1)).quantize(CENTS)

    @keyword("Converter Textos Em Preços")
    def parse_prices(self, texts: list[str]) -> list[Decimal]:
        return [self.parse_price(text) for text in texts]

    @keyword("Somar Preços")
    def sum_prices(self, *prices) -> Decimal:
        """Sums prices (or lists of prices) and rounds to cents.

        Arguments are intentionally untyped: a type hint would make Robot Framework
        convert a list argument into a string before calling the keyword.
        """
        total = Decimal("0")
        for price in prices:
            items = price if isinstance(price, list) else [price]
            total += sum((Decimal(str(item)) for item in items), Decimal("0"))
        return total.quantize(CENTS, rounding=ROUND_HALF_UP)
