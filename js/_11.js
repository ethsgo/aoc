let input = `
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
`.trim()

let inputShort = `
11111
19991
19191
19991
11111
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split(/\s+/).map((s) => [...s].map(Number))

const sim = (oct, steps) =>
  [...Array(steps)].map((_) => step(oct)).reduce((a, x) => a + x)

function step(oct) {
  function neighbours(y, x) {
    let result = []
    for (const dy of [-1, 0, 1]) {
      for (const dx of [-1, 0, 1]) {
        if (dy === 0 && dx === 0) continue
        const ny = y + dy
        const nx = x + dx
        if (ny >= 0 && ny < oct.length && nx >= 0 && nx < oct[ny].length)
          result.push([ny, nx])
      }
    }
    return result
  }

  let flashes = 0
  let stack = []

  for (let y = 0; y < oct.length; y++) {
    for (let x = 0; x < oct[y].length; x++) {
      oct[y][x]++
      if (oct[y][x] > 9) {
        stack.push([y, x])
      }
    }
  }

  while (stack.length > 0) {
    const [y, x] = stack.pop()
    flashes++
    for (const [ny, nx] of neighbours(y, x)) {
      oct[ny][nx]++
      if (oct[ny][nx] === 10) {
        stack.push([ny, nx])
      }
    }
  }

  for (let y = 0; y < oct.length; y++) {
    for (let x = 0; x < oct[y].length; x++) {
      if (oct[y][x] > 9) oct[y][x] = 0
    }
  }

  return flashes
}

const p1 = (oct) => sim(oct, 100)

function p2(oct) {
  const allZeroes = () => oct.every((row) => row.every((x) => x === 0))
  let steps = 0
  while (!allZeroes()) {
    step(oct)
    steps++
  }
  return steps
}

console.log(p1(parse(input)))
console.log(p2(parse(input)))
