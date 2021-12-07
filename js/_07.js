let input = '16,1,2,0,4,2,7,1,2,14'

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const numbers = (s) => s.split(/[^\d.]+/).map(Number)

const fuel = (crabs, position, scale) =>
  crabs.map((x) => Math.abs(x - position)).reduce((a, x) => a + x)

const p1 = (xs) => Math.min(...crabs.map((p) => fuel(crabs, p)))

const sumTo = (n) => (n * (n + 1)) / 2

const fuel2 = (crabs, position) =>
  crabs.map((x) => sumTo(Math.abs(x - position))).reduce((a, x) => a + x)

function p2(xs) {
  const s = Math.min(...xs)
  const e = Math.max(...xs)
  const range = Array.from({ length: e - s }, (x, i) => i + s)
  const fuels = range.map((p) => fuel2(crabs, p))
  return Math.min(...fuels)
}

let crabs = numbers(input)

console.log(p1(crabs))
console.log(p2(crabs))
