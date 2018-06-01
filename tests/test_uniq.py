from random import randint

def get_contract(chain):
    return chain.provider.get_or_deploy_contract("Unique")[0]

def get_gas_cost(chain, txn_hash):
    return chain.wait.for_receipt(txn_hash)["gasUsed"]

def test_simple(chain):
    contract = get_contract(chain)

    assert contract.call().uniquify([1, 1, 1]) == [1]
    assert contract.call().uniquify([1, 5, 1, 5, 6, 7, 8, 1, 1, 1, 1, 5, 5, 5, 1]) == [1, 5, 6, 7, 8]
    assert contract.call().uniquify([]) == []

def uniq(xs):
    seen = set()
    res = []
    for x in xs:
        if x not in seen:
            seen.add(x)
            res.append(x)
    return res

def test_random(chain):
    contract = get_contract(chain)

    max_len = 20
    reps = 50

    for _ in range(reps):
        xs = [randint(0, 2**256 - 1) for _ in range(randint(1, max_len))]
        assert contract.call().uniquify(xs) == uniq(xs)

def test_gas_all_same(chain):
    contract = get_contract(chain)

    length = 200
    all_same = [1 for _ in range(length)]

    txn = contract.transact().uniquify(all_same)
    gas_cost = get_gas_cost(chain, txn)

    print(gas_cost)

def test_big_gas(chain):
    contract = get_contract(chain)
    length = 100

    reps = 5

    width = 50

    gas_cost = 0

    for _ in range(reps):
        txn = contract.transact().uniquify([randint(0, width) for _ in range(length)])
        gas_cost += get_gas_cost(chain, txn)

    print(gas_cost//reps)
