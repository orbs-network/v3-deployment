#!/usr/bin/python3

import json
import os
from secrets import token_bytes
from sys import argv

from coincurve import PublicKey
from sha3 import keccak_256

# https://github.com/pcaversaccio/ethereum-key-generation-python
private_key = keccak_256(token_bytes(32)).digest()
public_key = PublicKey.from_valid_secret(private_key).format(compressed=False)[1:]
addr = keccak_256(public_key).digest()[-20:]

dest_dir = argv[1]

if not os.path.exists(dest_dir):
    os.makedirs(dest_dir)

with open(f"{dest_dir}/keys.json", "w") as f:
    f.write(json.dumps({"node-address": addr.hex(), "node-private-key": private_key.hex()}))

print('Public address: 0x' + addr.hex())
# print('private_key:', private_key.hex())
