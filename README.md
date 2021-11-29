# Advent of Code - Solidity/JS

[Advent of Code 2021](https://adventofcode.com/2021) in Solidity (and JS).

To run any of the Solidity contracts in the `contracts` folder:

```
npx hardhat solrun C20_01
```

(You'll have to do `npm install` the first time).

To run the JS solutions:

```
node js/20-01.js
```

If no inputs are passed in stdin, then the programs execute with the example
given in the puzzle. To pass input, pipe into stdin:

```
cat inputs/20-01 | npx hardhat solrun C20_01
cat inputs/20-01 | node js/20-01.js
```

https://twitter.com/ethsgo_
