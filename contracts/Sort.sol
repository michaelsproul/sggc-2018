/**
 * This file is part of the 1st Solidity Gas Golfing Contest.
 *
 * This work is licensed under Creative Commons Attribution ShareAlike 3.0.
 * https://creativecommons.org/licenses/by-sa/3.0/
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
        uint[] memory result = new uint[](n);

        uint[] memory A = input;
        uint[] memory B = result;
        // For swaps
        uint[] memory temp;

        // Index into the second slice
        // As an optimisation, i is (ab)used as the index into the first slice
        uint j2;
        // Ends of the slices
        uint sliceEnd1;
        uint sliceEnd2;

        // Bottom-up merge sort
        // Based on pseudo-code from https://en.wikipedia.org/wiki/Merge_sort
        for (uint width = 1; width < n; width = width + width) {
            // Take slices of length `width` along array A (these slices are sorted)
            for (uint i = 0; i < n; i = sliceEnd2) {
                // Merge A[i:i + width] with A[i + width: i + 2 * width] writing the result to B
                // j2 = min(i + width, n)
                j2 = i + width;
                if (j2 > n) {
                    j2 = n;
                }
                sliceEnd1 = j2;
                // sliceEnd2 = min(i + 2 * width, n)
                sliceEnd2 = j2 + width;
                if (sliceEnd2 > n) {
                    sliceEnd2 = n;
                }
                for (uint k = i; k < sliceEnd2; k++) {
                    if (i < sliceEnd1 && (j2 == sliceEnd2 || A[i] < A[j2])) {
                        B[k] = A[i];
                        i++;
                    } else {
                        B[k] = A[j2];
                        j2++;
                    }
                }
            }

            // Swap A and B
            temp = A;
            A = B;
            B = temp;
        }

        return A;
    }
}
