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
  let fishes = Array(9).fill(0)
  for (const x of xs) {
    fishes[x] += 1
  }
  for (let day = 0; day < 18; day++) {
    let newFishes = Array(9).fill(0)
    for (const [k, v] of fishes.entries()) {
      if (k === 0) {
        newFishes[6] = newFishes[6] + v
        newFishes[8] = newFishes[8] + v
      } else {
        newFishes[k - 1] = newFishes[k - 1] + v
      }
    }
    fishes = newFishes
  }
  return fishes.reduce((a, x) => a + x)
}

function p2(xs) {}

let xs = numbers(input)
console.log(p1(xs))
// console.log(p2(xs))
