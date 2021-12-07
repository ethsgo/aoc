let input = '16,1,2,0,4,2,7,1,2,14'

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const numbers = (s) => s.split(/[^\d.]+/).map(Number)

const id = (n) => n
const sumTo = (n) => (n * (n + 1)) / 2

const fuel = (crabs, position, scale) => {
  const r = crabs
    .map((x) => scale(Math.abs(x - position)))
    .reduce((a, x) => a + x)
  console.log(position, r)
  return r
}

const p1 = (xs) => Math.min(...crabs.map((p) => fuel(crabs, p, id)))
const p2 = (xs) => crabs.map((p) => fuel(crabs, 5, sumTo))

let crabs = numbers(input)

// console.log(p1(crabs))
console.log(p2(crabs))
