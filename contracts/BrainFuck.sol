/**
 * This file is part of the 1st Solidity Gas Golfing Contest.
 *
 * This work is licensed under Creative Commons Attribution ShareAlike 3.0.
 * https://creativecommons.org/licenses/by-sa/3.0/
 */

pragma solidity 0.4.24;

contract BrainFuck {
    /**
     * @dev Executes a BrainFuck program, as described at https://en.wikipedia.org/wiki/Brainfuck.
     *
     * Memory cells, input, and output values are all expected to be 8 bit
     * integers. Incrementing past 255 should overflow to 0, and decrementing
     * below 0 should overflow to 255.
     *
     * Programs and input streams may be of any length. The memory tape starts
     * at cell 0, and will never be moved below 0 or above 1023. No program will
     * output more than 1024 values.
     *
     * @param program The BrainFuck program.
     * @param input The program's input stream.
     * @return The program's output stream. Should be exactly the length of the
     *          number of outputs produced by the program.
     */
    function execute(bytes program, bytes input) public pure returns (bytes res) {
        // Instruction pointer
        uint ip;
        // Data pointer
        uint dp;
        // Input pointer
        uint inp;
        // Output pointer
        uint op;
        // Working memory
        uint8[1024] memory data;

        byte[1024] memory raw_output;

        uint n = program.length;

        uint[50] memory loop_stack;
        uint loop_stack_len;

        // Temp
        byte v;

        uint depth;

        while (ip < n) {
            byte ins = program[ip];

            if (ins == '>') {
                dp++;
            } else if (ins == '<') {
                dp--;
            } else if (ins == '+') {
                data[dp]++;
            } else if (ins == '-') {
                data[dp]--;
            } else if (ins == '.') {
                raw_output[op++] = byte(data[dp]);
            } else if (ins == ',') {
                data[dp] = uint8(input[inp++]);
            } else if (ins == '[') {
                // Push to the loop stack
                loop_stack[loop_stack_len++] = ip;

                // Run forwards to find the closing brace
                if (data[dp] == 0) {
                    depth = 0;
                    ip++;
                    v = program[ip];
                    // Search until depth = 0 and v = ']'
                    while (depth != 0 || v != ']') {
                        if (v == '[') {
                            depth++;
                        } else if (v == ']') {
                            depth--;
                        }
                        ip++;
                        v = program[ip];
                    }
                }
            } else if (ins == ']') {
                if (data[dp] != 0) {
                    // Jump back to last open brace
                    ip = loop_stack[loop_stack_len - 1];
                } else {
                    // Pop from the loop stack
                    loop_stack_len--;
                }
            }

            ip++;
        }

        // Copy output to a smaller array
        res = new bytes(op);
        for (uint i = 0; i < op; i++) {
            res[i] = raw_output[i];
        }
    }
}
