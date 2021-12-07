let input = '16,1,2,0,4,2,7,1,2,14'

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const numbers = (s) => s.split(/[^\d.]+/).map(Number)

function p1(crabs) {
  const m = crabs[crabs.length / 2]
  const fuel = crabs.map((x) => Math.abs(x - m))
  return fuel.reduce((a, x) => a + x)
}

let crabs = numbers(input)
crabs.sort()
console.log(p1(crabs))
//console.log(p2(crabs))
