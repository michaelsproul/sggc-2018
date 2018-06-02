/**
 * This file is part of the 1st Solidity Gas Golfing Contest.
 *
 * This work is licensed under Creative Commons Attribution ShareAlike 3.0.
 * https://creativecommons.org/licenses/by-sa/3.0/
 *
 * Implementation by Michael Sproul (https://sproul.xyz)
 */

pragma solidity 0.4.24;

contract IndexOf {
    /**
     * @dev Returns the index of the first occurrence of `needle` in `haystack`,
     *      or -1 if `needle` is not found in `haystack`.
     *
     * Input strings may be of any length <2^255.
     *
     * @param haystack_s The string to search.
     * @param needle_s The string to search for.
     * @return The index of `needle` in `haystack`, or -1 if not found.
     */
    // Gas: 1372734
    function indexOf(string haystack_s, string needle_s) public pure returns (int) {
        bytes memory haystack = bytes(haystack_s);
        bytes memory needle = bytes(needle_s);
        uint n = haystack.length;
        uint m = needle.length;
        uint i;
        uint x;

        if (n < m) {
            return -1;
        }

        // Rabin-Karp algorithm
        // Define our hash function as follows:
        // hash(x) = sum(256^i * x_i) mod 101
        // Treat the string as most-significant-byte first

        uint needle_hash = 0;
        uint substring_hash = 0;
        x = 1;
        for (i = m; i > 0; i--) {
            needle_hash = addmod(needle_hash, x * uint(needle[i - 1]), 101);
            substring_hash = addmod(substring_hash, x * uint(haystack[i - 1]), 101);
            x = mulmod(256, x, 101);
        }

        // x now equals 256^m

        uint stop = n - m + 1;

        for (i = 0; i < stop; i++) {
            if (needle_hash == substring_hash) {
                // Check that all the characters actually match
                bool matched = true;
                for (uint j = 0; j < m; j++) {
                    if (haystack[i + j] != needle[j]) {
                        matched = false;
                        break;
                    }
                }

                if (matched) {
                    return int(i);
                }
            }

            if (i != stop - 1) {
                // Else, update the hash for the next iteration
                // 1. Multiply by 256 (move every character 'left')
                substring_hash = mulmod(256, substring_hash, 101);

                // 2. Subtract the most significant char (position i)
                substring_hash = addmod(substring_hash, 101 - mulmod(x, uint(haystack[i]), 101), 101);

                // 3. Add the next char
                substring_hash = addmod(substring_hash, uint(haystack[i + m]) , 101);
            }
        }

        return -1;
    }
}
