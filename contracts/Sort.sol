/**
 * This file is part of the 1st Solidity Gas Golfing Contest.
 *
 * This work is licensed under Creative Commons Attribution ShareAlike 3.0.
 * https://creativecommons.org/licenses/by-sa/3.0/
 *
 * Implementation by Michael Sproul (https://sproul.xyz)
 */

pragma solidity 0.4.24;

contract Sort {
    /**
     * @dev Sorts a list of integers in ascending order.
     *
     * The input list may be of any length.
     *
     * @param input The list of integers to sort.
     * @return The sorted list.
     */
    function sort(uint[] input) public pure returns (uint[]) {
        if (input.length <= 1) {
            return input;
        }
        uint n = input.length;
        uint j;
        uint s1;
        uint s2;

        // Selection sort on small inputs (n=22 or less determined empirically)
        if (n < 23) {
            // p is the index of the first unsorted element
            // q is the index for min-finding loop
            // s1 is the min element for this iteration
            // s2 is the index of the min element
            // j is used as a temporary

            for (uint p = 0; p < n; p++) {
                s1 = input[p];
                s2 = p;
                for (uint q = p + 1; q < n; q++) {
                    j = input[q];
                    if (j < s1) {
                        s1 = j;
                        s2 = q;
                    }
                }
                input[s2] = input[p];
                input[p] = s1;
            }

            return input;
        }

        uint[] memory scratch = new uint[](n);

        // For swaps
        uint[] memory temp;

        // As an optimisation, i is used as the index into the first slice
        // j is the index into the second slice
        // Ends of the slices are s1 and s2
        // A=input, B=scratch

        // Bottom-up merge sort
        // Based on pseudo-code from https://en.wikipedia.org/wiki/Merge_sort
        for (uint width = 1; width < n; width = width + width) {
            // Take slices of length `width` along array A (these slices are sorted)
            for (uint i = 0; i < n; i = s2) {
                // Merge A[i:i + width] with A[i + width: i + 2 * width] writing the result to B
                // j = min(i + width, n)
                j = i + width;
                if (j > n) {
                    j = n;
                }
                s1 = j;
                // s2 = min(i + 2 * width, n)
                s2 = j + width;
                if (s2 > n) {
                    s2 = n;
                }
                for (uint k = i; k < s2; k++) {
                    if (i < s1 && (j == s2 || input[i] < input[j])) {
                        scratch[k] = input[i];
                        i++;
                    } else {
                        scratch[k] = input[j];
                        j++;
                    }
                }
            }

            // Swap input and scratch (input = A, scratch = B)
            temp = input;
            input = scratch;
            scratch = temp;
        }

        return input;
    }
}
