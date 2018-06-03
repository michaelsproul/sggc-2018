/**
 * This file is part of the 1st Solidity Gas Golfing Contest.
 *
 * This work is licensed under Creative Commons Attribution ShareAlike 3.0.
 * https://creativecommons.org/licenses/by-sa/3.0/
 */

pragma solidity 0.4.24;

contract Unique {
    /**
     * @dev Removes all but the first occurrence of each element from a list of
     *      integers, preserving the order of original elements, and returns the list.
     *
     * The input list may be of any length.
     *
     * @param input The list of integers to uniquify.
     * @return The input list, with any duplicate elements removed.
     */
    function uniquify(uint[] input) public pure returns (uint[] ret) {
        uint n = input.length;

        uint i;
        uint num_uniq;
        bool seen_zero;
        uint prev_val;

        uint[] memory hashmap = new uint[](n);

        for (; i < n; i++) {
            uint val = input[i];

            if (val != 0) {
                if (val == prev_val) {
                    continue;
                }
                prev_val = val;
                uint hash_idx = uint(sha3(val));

                uint idx = hash_idx % n;
                uint bucket_val = hashmap[idx];

                // If slot is empty, insert our val and add it to the list of uniq elements
                if (bucket_val == 0) {
                    hashmap[idx] = val;
                    input[num_uniq] = val;
                    num_uniq = num_uniq + 1;
                }
                // Otherwise, if we hit some value that's not our value, keep searching.
                // In the case where bucket_val == val, we don't need to do anything,
                // so we can just continue the loop.
                else if (bucket_val != val) {
                    for (uint j = 1; j < n; j++) {
                        idx = (hash_idx + j) % n;

                        bucket_val = hashmap[idx];

                        // Found our element => it's a duplicate, skip it and continue outer loop.
                        if (bucket_val == val) {
                            break;
                        }
                        // Found an empty slot => it's unique, store it and continue outer loop.
                        else if (bucket_val == 0) {
                            hashmap[idx] = val;
                            input[num_uniq] = val;
                            num_uniq = num_uniq + 1;
                            break;
                        }
                    }
                }
            } else if (!seen_zero) {
                seen_zero = true;
                input[num_uniq] = 0;
                num_uniq = num_uniq + 1;
            }
        }

        ret = new uint[](num_uniq);

        for (i = 0; i < num_uniq; i++) {
            ret[i] = input[i];
        }
    }
}
