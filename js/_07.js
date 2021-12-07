let input = '16,1,2,0,4,2,7,1,2,14'

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const numbers = (s) => s.split(/[^\d.]+/).map(Number)

const fuel = (xs, m) => xs.map((x) => Math.abs(x - m)).reduce((a, x) => a + x)

function p1(xs) {
  const n = xs.length
  if (n % 2 == 0) {
    return fuel(xs, xs[n / 2])
  } else {
    return Math.min(fuel(xs, xs[n / 2]), fuel(xs, xs[n / 2 + 1]))
  }
}

let crabs = numbers(input)
crabs.sort()
console.log(p1(crabs))
//console.log(p2(crabs))
