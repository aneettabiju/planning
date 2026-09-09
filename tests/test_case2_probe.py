"""Intentional failure for Ask Ark Case 2 testing."""

from __future__ import annotations

import unittest


class Case2ProbeTests(unittest.TestCase):
    def test_intentional_probe_failure(self) -> None:
        self.fail("Intentional Case 2 probe failure — fix this assertion for the demo")


if __name__ == "__main__":
    unittest.main()
