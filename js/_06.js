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

function parse(input) {
  const xs = numbers(input)
  let fishes = Array(9).fill(0)
  for (const x of xs) {
    fishes[x] += 1
  }
  return fishes
}

function grow(fishes, days) {
  for (; days > 0; days--) {
    let newFishes = Array(9).fill(0)
    for (let k = 0; k < 9; k++) {
      const v = fishes[k]
      if (k === 0) {
        newFishes[6] = v
        newFishes[8] = v
      } else {
        newFishes[k - 1] = newFishes[k - 1] + v
      }
    }
    fishes = newFishes
  }
  return fishes.reduce((a, x) => a + x)
}

const p1 = (fishes) => grow(fishes, 80)
const p2 = (fishes) => grow(fishes, 256)

let fishes = parse(input)
console.log(p1(fishes))
console.log(p2(fishes))
