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
    function indexOf(string haystack_s, string needle_s) public pure returns (int) {
        bytes memory haystack = bytes(haystack_s);
        bytes memory needle = bytes(needle_s);
        uint n = haystack.length;
        uint m = needle.length;
        uint i = m - 1;
        uint stop = n - m;
        bool matched;
        uint x = 1;
        uint j;

        if (m == 0) {
            return 0;
        }

        if (n < m) {
            return -1;
        }

        // Rabin-Karp algorithm
        // Define our hash function as follows:
        // hash(x) = sum(256^i * x_i) mod 101
        // Treat the string as most-significant-byte first

        uint needle_hash;
        uint substring_hash;

        for (; i > 1; i = i - 2) {
            needle_hash += x * uint(needle[i]);
            substring_hash += x * uint(haystack[i]);
            x *= 256;

            needle_hash = addmod(needle_hash, x * uint(needle[i - 1]), 101);
            substring_hash = addmod(substring_hash, x * uint(haystack[i - 1]), 101);
            x = mulmod(256, x, 101);
        }

        // Hash the last one or two bytes
        if (i != 0) {
            needle_hash += x * uint(needle[i]);
            substring_hash += x * uint(haystack[i]);
            x *= 256;
        }

        needle_hash = addmod(needle_hash, x * uint(needle[0]), 101);
        substring_hash = addmod(substring_hash, x * uint(haystack[0]), 101);
        x = mulmod(256, x, 101);

        // x now equals 256^m

        for (i = 0; i != stop; i++) {
            if (needle_hash == substring_hash) {
                // Check that all the characters actually match
                matched = true;
                for (j = 0; j != m; j++) {
                    if (haystack[i + j] != needle[j]) {
                        matched = false;
                        break;
                    }
                }

                if (matched) {
                    return int(i);
                }
            }

            // Else, update the hash for the next iteration
            // 1. Move all characters up a position by multiplying by 256
            // 2. Subtract the most significant char (position i) (add -256^m * char)
            // 3. Add the next char
            uint z = x * (303 - uint(haystack[i]));

            substring_hash = addmod(256 * substring_hash + z, uint(haystack[i + m]), 101);
        }

        // Check for a match once more on the way out
        if (needle_hash == substring_hash) {
            // Check that all the characters actually match
            matched = true;
            for (j = 0; j != m; j++) {
                if (haystack[i + j] != needle[j]) {
                    matched = false;
                    break;
                }
            }

            if (matched) {
                return int(i);
            }
        }

        return -1;
    }
}
