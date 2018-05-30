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
        uint8 b;
        uint8 c;
        for (uint i = 0; i < m; i++) {
            // ith byte from characters c = 2i and c = 2i + 1
            b = uint8(inputBytes[i + i]);
            // Largest byte is odd, '0'-'9'
            if (b & 0x10 != 0) {
                b = 16 * (b & 0x0F);
            }
            // Otherwise, 'a'-'f' or 'A'-'F'
            else {
                b = 16 * ((b & 0x0F) + 9);
            }

            c = uint8(inputBytes[i + i + 1]);
            // Largest byte is odd, '0'-'9'
            if (c & 0x10 != 0) {
                output[i] = byte(b | (c & 0x0F));
            }
            // Otherwise, 'a'-'f' or 'A'-'F'
            else {
                output[i] = byte(b | ((c & 0x0F) + 9));
            }
        }

        return output;
    }
}
