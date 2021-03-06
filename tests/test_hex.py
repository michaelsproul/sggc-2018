import random

def get_contract(chain):
    return chain.provider.get_or_deploy_contract("HexDecoder")[0]

# TODO: dedupe this
def get_gas_cost(chain, txn_hash):
    return chain.wait.for_receipt(txn_hash)["gasUsed"]

def to_bytes(s: str) -> bytes:
    return bytes([ord(c) for c in s])

def test_simple(chain):
    contract = get_contract(chain)

    test_cases = ["deadbeef", "e4", "0ABCDEF0aaadfF"]

    for x in test_cases:
        assert to_bytes(contract.call().decode(x)) == bytes.fromhex(x)

big = "3a6ce44d45b3cfcb5f457785f945015600656e80a28d79e97574971c7b8019b1bf96aa6ef1d1c3fa514fac5ec567fe07cc1685bda5a05b3ea9a1bbd677b924ad7d3560e11a784c16acb91a4afcbcec832d2e888053b0b261226a482bdae50a6ee287fd0e84056cc67e987c9438a24aae0085f84a7613761d86a4de4207d106f510f4b9ea05b4c2bd7230d106e140dc4b406efa3f1839a2e5b6d09ef7fc2dc756788b149c7a566556cef7084db77b80fae136a1d414d169f88db9ff0ae2321d242d4d145e259a77c1aba23a1ed8c39095673fc2766cab3727b788780c14c363129b9df9da501eced3598747f549781904f399eaf6e237e84dcd4e95accfe4817ccda868a024deb0de68e8a2b11d8c98b0229118b524c7831c09976df6c6435d7f3c2aa574884970d7c3fafabc2382f634718ac4c7cf4218b4c96ea254996e8fe9acfac3b7933223a0310a71c78a69ae445a18dd08bc8a864d15e2cfe50071c63e2fdac9ae0588f386b689af369f471b44cebe4d752cd4e468a59284f666c7d1276ca3c36bcc315f10c84d571ac502e710e3551ebfdb42e0bf031eee3f944ea369703d370c22ab91f3a483f12e0a247d1e75e2dc2e3ca5a5f495d23dbacd8f86133edd80ee6a6f92dbf05b09bfc369a08efa6c3b97dc6854f26a69c6d03c55d0fc182b1c723244295068dfa17e3f92ba7b944d85d169aed440bd0069df74e61b2823c06f8c6c1d7737ed8ec764fc6115b47dfd12dc363bd0afe20026370d70399e07c1c757102e59675561bdfac0a252cb144d87fd8ea0a0a82e69107b8134a14f8ef17274a763ee3a6d7a97520d3ad3fa1c6fbc34bd70585f0bf16e5b9a6a7091f878c12f5546cd3fd17d9140b50c1096646e39cc618c1a66f816447fdd3d0e3b1e2514b57449cc9ee38dfb162b0ed4898cd2fd9b28105141160c96a1537ffe0ce5aadc77996fc8730d6f43e51a69ca51bb9a968390689d75afc7c509e442dfa73c6d63addf9415d56509a9ef972f3438d6795ccfdfed148f837b163c1716c84e97c1ee8ac1877189646e5f9d263bb46bb529b06a20e423fcf4cd556fe34f2b19b79b842a9789c343d298c31514e747dc2041b94fcd26962bfe90fb623882563cb5e450c562cab8447d2284cb63432167ee4597e8fbcfbf1ce4ada647aafe168ed55acc5fb80e565c44706bac10d4903d63450e8bba4b8221153480176acb8191840d423df10cc5b314d77d27c66802a82ac3a31d3678f17be1110d760a0d8eedf106c73441445bf2403caf0fa15db1313208b09359d556e96f5e2e70de8988006c0b2bf13ef5c12e3f1f11ad76457ca1ede2ad4c6a45b6c239a4f79f916b9c8216074f7ce9e8d0b56f90bbfbb106a8f72811693644eff8d06f12ebfff32969679b7a2a79b5039d558c70e0d0255d27f448af8f2c9e4da190c02428f063243cce".lower()

def test_big(chain):
    contract = get_contract(chain)

    assert to_bytes(contract.call().decode(big)) == bytes.fromhex(big)

    txn_hash = contract.transact().decode(big)
    gas_used = get_gas_cost(chain, txn_hash)

    print("Gas used: {}".format(gas_used))

alphabet = list("0123456789abcdefABCDEF")

def test_gas_random(chain):
    contract = get_contract(chain)

    reps = 1

    print("")

    for length in range(2, 1000, 8):
        print("{}".format(length), end="")

        for _ in range(reps):
            data = "".join(random.choices(alphabet, k=length))
            txn = contract.transact().decode(data)
            gas_cost = get_gas_cost(chain, txn)

            print(",{}".format(gas_cost), end="")

        print("")
