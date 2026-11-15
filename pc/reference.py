"""Offline AES reference. Member 6 adds serial I/O in pc/demo.py."""
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

KEY = bytes(range(16))


def transform(block, *, decrypt=False):
    if len(block) != 16:
        raise ValueError("Expected one 16-byte block")
    cipher = Cipher(algorithms.AES(KEY), modes.ECB())
    operation = cipher.decryptor() if decrypt else cipher.encryptor()
    return operation.update(block) + operation.finalize()


def request(led_on):
    return transform(bytes([int(led_on)]) + bytes(15))


def reply(led_on):
    return transform(bytes([0xA0, int(led_on)]) + bytes(14))


if __name__ == "__main__":
    plain = bytes.fromhex("00112233445566778899aabbccddeeff")
    expected = bytes.fromhex("69c4e0d86a7b0430d8cdb78070b4c55a")
    if transform(plain) != expected or transform(expected, decrypt=True) != plain:
        raise SystemExit("AES vector failed")
    for state, sent, received in (
        (True, "e37cd363dd7c87a09aff0e3e60e09c82", "b026dbf27fcdfabeeab01ed0cb78ac66"),
        (False, "c6a13b37878f5b826f4f8162a1c8d879", "966aab7bda958e77dd00c494cfc001d6"),
    ):
        if request(state).hex() != sent or reply(state).hex() != received:
            raise SystemExit("LED vector failed")
        print(f"{'ON ' if state else 'OFF'} TX={sent} RX={received}")
    print("PASS: offline reference vectors")
