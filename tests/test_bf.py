from random import randint

def get_contract(chain):
    return chain.provider.get_or_deploy_contract("BrainFuck")[0]

def get_gas_cost(chain, txn_hash):
    return chain.wait.for_receipt(txn_hash)["gasUsed"]

def to_bytes(s: str) -> bytes:
    return bytes([ord(c) for c in s])

def test_simple(chain):
    contract = get_contract(chain)

    add1 = b",+."

    assert contract.call().execute(add1, b"0") == "1"

    add2and5 = b"++>+++++[<+>-]<."

    assert contract.call().execute(add2and5, b"") == "\x07"

    add = b",>,[<+>-]<."

    assert contract.call().execute(add, b"\x00\xff") == "\xff"

def test_brace_space(chain):
    contract = get_contract(chain)

    program = b",[This is a very long blob of text intended to make the distance between two square brackets at least 256 characters This will help test the efficiency of Brainfuck implementations at finding matching parentheses and break any assumptions about jumps being short-]"

    assert contract.call().execute(program, b"\x08") == ""

def test_int_overflow(chain):
    contract = get_contract(chain)

    program = b">,+.<."
    assert contract.call().execute(program, b"\xff") == "\x00\x00"

def test_big_alloc(chain):
    contract = get_contract(chain)

    program = b",[>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>,],."
    data = bytes.fromhex("010101010101010101010101010101010101010101010101010101010101010080")
    assert contract.call().execute(program, data) == "\x80"

def test_nested_loop(chain):
    contract = get_contract(chain)

    program = b"[[]++++++++[][[]]+]+++."
    assert contract.call().execute(program, b"") == "\x03"

def test_hello_world(chain):
    contract = get_contract(chain)

    hello = b"++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."

    assert contract.call().execute(hello, b"") == "Hello World!\n"

    txn = contract.transact().execute(hello, b"")
    gas_cost = get_gas_cost(chain, txn)

    print("\nGas cost: {}".format(gas_cost))

def test_shift_left_and_right(chain):
    contract = get_contract(chain)

    program = b"><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>."

    assert contract.call().execute(program, b"") == "\x01"

    txn = contract.transact().execute(program, b"")
    gas_cost = get_gas_cost(chain, txn)

    print("Gas cost: {}".format(gas_cost))


