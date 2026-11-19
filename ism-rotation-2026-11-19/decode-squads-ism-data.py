#!/usr/bin/env python3
"""Decode the Data field of a Squads proposal that calls the Hyperlane Solana
multisig ISM (program 4MzF7HCfxuwj4EFHqZSEpvkcZZvv1mF37DP4pDHwR5VQ).

Usage:  python3 decode-squads-ism-data.py <base58 data copied from the Squads UI>

Layout (Hyperlane sealevel multisig-ism-message-id, instruction SetValidatorsAndThreshold):
  8 bytes  discriminator (0x01 x 8)
  1 byte   enum variant (1 = SetValidatorsAndThreshold)
  4 bytes  domain (u32 little-endian)
  4 bytes  number of validators (u32 little-endian)
  20 bytes per validator (Ethereum-style address)
  1 byte   threshold
"""
import sys

ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

def b58decode(s: str) -> bytes:
    n = 0
    for ch in s:
        n = n * 58 + ALPHABET.index(ch)
    raw = n.to_bytes((n.bit_length() + 7) // 8, "big") if n else b""
    pad = len(s) - len(s.lstrip("1"))
    return b"\x00" * pad + raw

def main():
    if len(sys.argv) != 2:
        print(__doc__); sys.exit(1)
    d = b58decode(sys.argv[1].strip())
    assert d[:8] == b"\x01" * 8, "discriminator != 0x01*8: not a multisig-ism instruction"
    variant = d[8]
    names = {0: "Init", 1: "SetValidatorsAndThreshold", 2: "GetOwner", 3: "TransferOwnership"}
    print("instruction :", names.get(variant, f"unknown({variant})"))
    if variant != 1:
        sys.exit(0)
    domain = int.from_bytes(d[9:13], "little")
    n = int.from_bytes(d[13:17], "little")
    vals = ["0x" + d[17 + 20 * i: 37 + 20 * i].hex() for i in range(n)]
    threshold = d[17 + 20 * n]
    assert len(d) == 18 + 20 * n, f"unexpected length {len(d)}"
    print("domain      :", domain, "(132556 = Terra Classic columbus-5)")
    print("validators  :", n)
    for i, v in enumerate(vals, 1):
        print(f"  {i}. {v}")
    print("threshold   :", threshold)

if __name__ == "__main__":
    main()
