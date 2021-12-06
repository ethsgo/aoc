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
  let fishes = new Map()
  for (const x of xs) {
    fishes.set(x, (fishes.get(x) ?? 0) + 1)
  }
  for (let day = 0; day < 80; day++) {
    let newFishes = new Map()
    for (const [k, v] of fishes) {
      if (k === 0) {
        newFishes.set(6, (newFishes.get(6) ?? 0) + v)
        newFishes.set(8, (newFishes.get(8) ?? 0) + v)
      } else {
        newFishes.set(k - 1, (newFishes.get(k - 1) ?? 0) + v)
      }
    }
    fishes = newFishes
  }
  return [...fishes.values()].reduce((a, x) => a + x)
}

function p2(xs) {}

let xs = numbers(input)
console.log(p1(xs))
// console.log(p2(xs))
