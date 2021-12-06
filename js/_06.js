let input = '3,4,3,1,2'

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString()
}

function numbers(s) {
  return s
    .split(/[^\d.]+/)
    .filter((t) => t !== '')
    .map(Number)
}

function p1(xs) {
  return xs
}

function p2(xs) {}

let xs = numbers(input)
console.log(p1(xs))
// console.log(p2(xs))
