let input = '16,1,2,0,4,2,7,1,2,14'

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const numbers = (s) => s.split(/[^\d.]+/).map(Number)

const sum = (xs) => xs.reduce((a, x) => a + x)
const fuel = (xs, m) => sum(xs.map((x) => Math.abs(x - m)))

// The median works for part 1 because of the optimality property: it is the
// value with the lowest absolute distance to the data.
//
// i.e., the median minimizes the sum of absolute deviations (l1-norm).
//
// https://math.stackexchange.com/questions/113270/the-median-minimizes-the-sum-of-absolute-deviations-the-ell-1-norm
//
// The median is the middle element in case the number of elements is odd. In
// case the number of elements is even, any number (inclusive) between the two
// elements can be considered as the median. Generally, the arithmetic mean of
// these two values is considered as a median, but either of these two values
// also minimize the sum of distances, and can be considered as the median.

const p1 = (xs) => fuel(xs, xs[Math.floor(xs.length / 2)])

const sumTo = (n) => (n * (n + 1)) / 2
const fuel2 = (xs, m) => sum(xs.map((x) => sumTo(Math.abs(x - m))))

// The arithmetic mean works for part 2 because it minimizes the sum of squared
// deviations (x - m)^2.
//
// In our case, we're not minimizing the square n^2 but instead the binomial
// coefficient (n . (n + 1)) / 2. However, because of the n^2 in there, the
// arithmetic mean is close to optimal. Assuming the mean is less that 0.5 from
// the best position, we try both the integers around the mean.

function p2(xs) {
  const m = sum(xs) / xs.length
  return Math.min(fuel2(xs, Math.floor(m)), fuel2(xs, Math.ceil(m)))
}

let crabs = numbers(input)
crabs.sort((x, y) => x - y)

console.log(p1(crabs))
console.log(p2(crabs))
