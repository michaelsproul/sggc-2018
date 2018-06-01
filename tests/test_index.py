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

