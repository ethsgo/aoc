let input = '3,4,3,1,2'

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const numbers = (s) => s.split(/[^\d.]+/).map(Number)

function parse(input) {
  let fishes = Array(9).fill(0)
  for (const x of numbers(input)) {
    fishes[x] += 1
  }
  return fishes
}

function grow(fishes, days) {
  let f = [...fishes]

  for (; days > 0; days--) {
    const newFish = f.shift()
    f.push(newFish)
    f[6] += newFish
  }

  return f.reduce((a, x) => a + x)
}

const p1 = (fishes) => grow(fishes, 80)
const p2 = (fishes) => grow(fishes, 256)

let fishes = parse(input)
console.log(p1(fishes))
console.log(p2(fishes))
