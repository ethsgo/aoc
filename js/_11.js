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

function sim(oct, steps) {
  oct = [...oct]
  return [...Array(steps)].map((_) => step(oct)).reduce((a, x) => a + x)
}

function vis(oct) {
  console.log()
  for (let j = 0; j < oct.length; j++) {
    console.log(oct[j].map((x) => (x < 10 ? ` ${x}` : `${x}`)).join(''))
  }
  console.log()
}

function step(oct) {
  function neighbours(y, x) {
    let result = []
    for (let dy of [-1, 0, 1]) {
      for (let dx of [-1, 0, 1]) {
        if (dy === 0 && dx === 0) continue
        let ny = y + dy
        let nx = x + dx
        if (ny >= 0 && ny < oct.length && nx >= 0 && nx < oct[ny].length)
          result.push([ny, nx])
      }
    }
    return result
  }

  let flashes = 0
  let q = []

  for (let j = 0; j < oct.length; j++) {
    for (let i = 0; i < oct[j].length; i++) {
      oct[j][i]++
      if (oct[j][i] > 9) {
        q.push([j, i])
      }
    }
  }

  while (q.length > 0) {
    let [y, x] = q.shift()
    flashes++
    for (let [ny, nx] of neighbours(y, x)) {
      oct[ny][nx]++
      if (oct[ny][nx] === 10) {
        q.push([ny, nx])
      }
    }
  }

  for (let j = 0; j < oct.length; j++) {
    for (let i = 0; i < oct[j].length; i++) {
      if (oct[j][i] > 9) oct[j][i] = 0
    }
  }

  return flashes
}

const p1 = (oct) => sim(oct, 100)

const oct = parse(input)
console.log(p1(oct))
