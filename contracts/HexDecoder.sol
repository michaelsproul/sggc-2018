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
        bytes memory inputBytes = bytes(input);
        uint m = inputBytes.length;
        m = m / 2;
        output = new bytes(m);
        uint x;
        uint y;
        uint idx;
        // Loop unrolling, for shits and giggles
        for (uint i = 1; i < m; i = i + 2) {
            // This little formula works because only '0'-'9' have bit 0x10 set,
            // so when we mask and add 9 we get 25 + i = i (mod 25).
            // For 'a'-'f' and 'A'-'F', the mask and add takes 0x41 -> 0x01 -> 10 and so on.
            idx = i + i;
            x = uint(inputBytes[idx - 2]);
            x = 16 * addmod(x & 0x1F, 9, 25);
            y = uint(inputBytes[idx - 1]);
            output[i - 1] = byte(x | addmod(y & 0x1F, 9, 25));

            x = uint(inputBytes[idx]);
            x = 16 * addmod(x & 0x1F, 9, 25);
            y = uint(inputBytes[idx + 1]);
            output[i] = byte(x | addmod(y & 0x1F, 9, 25));
        }

        // If m is odd, fill in that last byte
        if (m % 2 != 0) {
            x = uint(inputBytes[m + m - 2]);
            x = 16 * addmod(x & 0x1F, 9, 25);
            y = uint(inputBytes[m + m - 1]);
            output[i - 1] = byte(x | addmod(y & 0x1F, 9, 25));
        }
    }
}
