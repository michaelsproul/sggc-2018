from random import randint

def get_contract(chain):
    return chain.provider.get_or_deploy_contract("Sort")[0]

def get_gas_cost(chain, txn_hash):
    return chain.wait.for_receipt(txn_hash)["gasUsed"]

def test_gas(chain):
    contract = get_contract(chain)

    txn_hash = contract.transact().sort([i for i in range(1000)])
    gas_cost = get_gas_cost(chain, txn_hash)

    print("Gas cost: {}".format(gas_cost))

def test_simple(chain):
    contract = get_contract(chain)

    assert contract.call().sort([4, 5, 3, 1]) == [1, 3, 4, 5]
    assert contract.call().sort([3, 1, 2]) == [1, 2, 3]
    l = [124123, 123125, 123123, 1235521, 19289023, 19203, 1]
    assert contract.call().sort(l) == sorted(l)

def test_random(chain):
    contract = get_contract(chain)

    reps = 100
    max_len = 50

    for _ in range(reps):
        length = randint(1, max_len)
        l = [randint(0, 2**256 - 1) for _ in range(length)]
        assert contract.call().sort(l) == sorted(l)
