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
    assert contract.call().uniquify([0, 0, 0, 0]) == [0]

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

EXAMPLE = [2637247833, 877743251, 209692859, 1293283540, 2440110609, 2529869825, 831836708, 3444688935, 2458134910, 2903343198, 274316355, 2321765972, 2278863911, 1810166378, 2374455075, 731513777, 2898409286, 4097825859, 1259402789, 3263232751, 678840525, 2039456958, 2869131234, 2059737611, 74002340, 3467056401, 2274487945, 375603017, 1139236568, 1438726890, 747634706, 3383405601, 1926749286, 2321407811, 814044042, 1152514529, 353015166, 998842806, 1873864071, 3689011439, 2352343408, 2104457113, 841310424, 3464147682, 3383264448, 2507330667, 2949910911, 1118079467, 3612893132, 111863391, 2072617955, 1007297632, 4094781665, 17980781, 3159482341, 82382249, 1501896686, 3604375622, 3743030098, 1415511530, 3236118966, 758385377, 1824732723, 3144891537]

def test_example_gas(chain):
    contract = get_contract(chain)

    txn = contract.transact().uniquify(EXAMPLE)
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
