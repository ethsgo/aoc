# Advent of Code - Solidity/JS

[Advent of Code 2021](https://adventofcode.com/2021) in Solidity (and JS).

## Prerequisites

You only need node to be installed on your machine. To get the rest of the
dependencies, run `npm install` after checking out this repository.

## Using

To run any of the Solidity contracts in the `contracts` folder:

```
npx hardhat solrun _01
```

To run the JS solutions:

```
node js/_01.js
```

If no inputs are passed in stdin, then the programs execute with the example
given in the puzzle. To pass input, pipe into stdin:

```
cat inputs/_01 | npx hardhat solrun _01
cat inputs/_01 | node js/_01.js
```

## Say hello

[https://twitter.com/ethsgo\_](https://twitter.com/ethsgo_)
