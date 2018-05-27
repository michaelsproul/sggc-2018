/**
 * This file is part of the 1st Solidity Gas Golfing Contest.
 *
 * This work is licensed under Creative Commons Attribution ShareAlike 3.0.
 * https://creativecommons.org/licenses/by-sa/3.0/
 */

pragma solidity 0.4.24;

contract Sort {
    // TODO: optimize
    function min(uint x, uint y) private pure returns (uint) {
        if (x <= y) {
            return x;
        } else {
            return y;
        }
    }

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
        uint[] memory result = new uint[](input.length);

        uint[] memory A = input;
        uint[] memory B = result;
        uint[] memory temp; // for swaps

        // Index into the first slice
        uint j1;
        // Index into the second slice
        uint j2;
        // End of slices
        uint sliceEnd1;
        uint sliceEnd2;

        // Bottom-up merge sort
        // Based on pseudo-code from https://en.wikipedia.org/wiki/Merge_sort
        for (uint width = 1; width < input.length; width *= 2) {
            // Take slices of length `width` along array A (these slices are sorted)
            for (uint i = 0; i < input.length; i = sliceEnd2) {
                // Merge A[i:i + width] with A[i + width: i + 2 * width]
                // writing the result to B
                j1 = i;
                j2 = i + width;
                sliceEnd1 = j2;
                sliceEnd2 = min(i + 2 * width, input.length);
                for (uint k = i; k < sliceEnd2; k++) {
                    if (j1 < sliceEnd1 && (j2 >= sliceEnd2 || A[j1] <= A[j2])) {
                        B[k] = A[j1];
                        j1++;
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
