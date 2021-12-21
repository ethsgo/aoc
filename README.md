# Advent of Code - Solidity/JS

[Advent of Code 2021](https://adventofcode.com/2021) in Solidity (and JS).

## Prerequisites

You only need node to be installed on your machine. To get the rest of the
dependencies, run `npm install` after checking out this repository.

## Using

To run any of the Solidity contracts in the `contracts` folder:

    npx hardhat exec _01

It prints a gas estimate and the return from the main function in the contract.

To run the JS solutions:

    node js/_01.js

If no inputs are passed in stdin, then the programs execute with the example
given in the puzzle. To pass input, pipe into stdin:

    cat inputs/_01 | npx hardhat exec _01
    cat inputs/_01 | node js/_01.js

Gas estimates are omitted when input is passed via stdin, because otherwise it
takes too long. Even so, we sometimes hit memory limits with hardhat. As a
workaround, set the following environment variable and run npx hardhat again.
This allows hardhat to use more memory than the default.

    export NODE_OPTIONS="--max-old-space-size=4096"

Unfortunately, even that is not enough to run the Solidity solutions for
problems 12, 15, 18 and 21 on the full input (they work on the smaller
examples).

## By

[https://twitter.com/ethsgo\_](https://twitter.com/ethsgo_)
