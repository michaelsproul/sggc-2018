from random import randint

def get_contract(chain):
    return chain.provider.get_or_deploy_contract("IndexOf")[0]

def get_gas_cost(chain, txn_hash):
    return chain.wait.for_receipt(txn_hash)["gasUsed"]

def test_simple(chain):
    contract = get_contract(chain)

    assert contract.call().indexOf("hello", "hello") == 0
    assert contract.call().indexOf("hello world this is me", "world") == 6
    assert contract.call().indexOf("hell", "hello") == -1
    assert contract.call().indexOf("hell hell heck hell hella", "hello") == -1

def test_match_tease(chain):
    contract = get_contract(chain)

    haystack = "a" * 1000 + "b"
    needle = "a" * 50 + "b"

    assert contract.call().indexOf(haystack, needle) == haystack.find(needle)

    txn = contract.transact().indexOf(haystack, needle)
    gas_cost = get_gas_cost(chain, txn)

    print("Gas cost: {}".format(gas_cost))
