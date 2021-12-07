let input = '16,1,2,0,4,2,7,1,2,14'

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const numbers = (s) => s.split(/[^\d.]+/).map(Number)

const id = (n) => n
const sumTo = (n) => (n == 0 ? 0 : sumTo(n - 1) + n)

const fuel = (crabs, position, scale) =>
  crabs.map((x) => scale(Math.abs(x - position))).reduce((a, x) => a + x)

const p1 = (xs) => Math.min(...crabs.map((p) => fuel(crabs, p, id)))
const p2 = (xs) => Math.min(...crabs.map((p) => fuel(crabs, p, sumTo)))

let crabs = numbers(input)

console.log(p1(crabs))
console.log(p2(crabs))
