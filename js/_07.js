let input = '16,1,2,0,4,2,7,1,2,14'

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const numbers = (s) => s.split(/[^\d.]+/).map(Number)

function median(xs) {
  xs = [...xs]
  xs.sort()
  const n = xs.length
  if (n % 2 == 0) {
    return (xs[n / 2] + xs[n / 2 + 1]) / 2
  } else {
    return xs[n / 2]
  }
}

const fuel = (crabs, position) =>
  crabs.map((x) => Math.abs(x - position)).reduce((a, x) => a + x)

// The median minimizes the sum of absolute deviations (l1-norm).
//
// The median is the middle element in case the number of elements is odd. In
// case the number of elements is even, any number (inclusive) between the two
// elements can be considered as the median. Generally, the arithmetic mean of
// these two values is considered as a median, but either of these two values
// also minimize the sum of distances, and can be considered as the median.
//
// https://math.stackexchange.com/questions/113270/the-median-minimizes-the-sum-of-absolute-deviations-the-ell-1-norm

const p1 = (xs) => fuel(xs, xs[Math.floor(xs.length / 2)])

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
crabs.sort((x, y) => x - y)

console.log(p1(crabs))
console.log(p2(crabs))
