from random import randint

def get_contract(chain):
    return chain.provider.get_or_deploy_contract("BrainFuck")[0]

def get_gas_cost(chain, txn_hash):
    return chain.wait.for_receipt(txn_hash)["gasUsed"]

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

    assert contract.call().execute(program, b"") == b""

def test_hello_world(chain):
    contract = get_contract(chain)

    hello = b"++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."

    assert contract.call().execute(hello, b"") == "Hello World!\n"

