/**
 * This file is part of the 1st Solidity Gas Golfing Contest.
 *
 * This work is licensed under Creative Commons Attribution ShareAlike 3.0.
 * https://creativecommons.org/licenses/by-sa/3.0/
 *
 * Implementation by Michael Sproul (https://sproul.xyz)
 */

pragma solidity 0.4.24;

contract HexDecoder {
    /**
     * @dev Decodes a hex-encoded input string, returning it in binary.
     *
     * Input strings may be of any length, but will always be a multiple of two
     * bytes long, and will not contain any non-hexadecimal characters.
     *
     * @param input The hex-encoded input.
     * @return The decoded output.
     */
    function decode(string input) public pure returns (bytes output) {
        // 0 in ASCII is 48
        // A in ASCII is 65
        // a in ASCII is 97
        bytes memory inputBytes = bytes(input);
        uint n = inputBytes.length;
        uint m = n / 2;
        output = new bytes(m);
        uint j;
        uint8 b;
        uint8 c;
        for (uint i = 0; i < m; i++) {
            // ith byte from characters j = 2i and j = 2i + 1
            j = i + i;
            b = uint8(inputBytes[j]);
            // 57 = '9'
            if (b < 58) {
                b = (b - 48) << 4;
            }
            // 70 = 'F'
            else if (b <  71) {
                b = (b - 55) << 4;
            } else {
                // a = 10
                b = (b - 87) << 4;
            }

            j++;
            c = uint8(inputBytes[j]);
            // 57 = '9'
            if (c < 58) {
                c = (c - 48);
            }
            // 70 = 'F'
            else if (c <  71) {
                c = (c - 55);
            } else {
                // a = 10
                c = (c - 87);
            }

            output[i] = byte(b | c);
        }

        return output;
    }
}
