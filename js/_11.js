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

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split(/\s+/).map((s) => [...s].map(Number))

function sim(oct, steps) {
  oct = [...oct]
  return [...Array(steps)].map((_) => step(oct)).reduce((a, x) => a + x)
}

function step(oct) {
  const neighbours2 = (y, x) => [
    ...(y > 0 ? [[y - 1, x]] : []),
    ...(y + 1 < oct.length ? [[y + 1, x]] : []),
    ...(x > 0 ? [[y, x - 1]] : []),
    ...(x + 1 < oct[y].length ? [[y, x + 1]] : []),
  ]

  function neighbours(y, x) {
    let result = []
    for (let dy of [-1, 0, 1]) {
      for (let dx of [-1, 0, 1]) {
        let ny = y + dy
        let nx = x + dx
        if (ny > 0 && ny < oct.length && nx > 0 && nx < oct[y].length)
          result.push([ny, nx])
      }
    }
    return result
  }

  let flashes = 0

  for (let j = 0; j < oct.length; j++) {
    for (let i = 0; i < oct[j].length; i++) {
      oct[j][i]++
    }
  }

  for (let j = 0; j < oct.length; j++) {
    for (let i = 0; i < oct[j].length; i++) {
      if (oct[j][i] <= 9) continue
      flashes++
      let stack = neighbours(j, i)
      while (stack.length > 0) {
        let [y, x] = stack.pop()
        oct[y][x]++
        if (oct[y][x] <= 9) continue
        flashes++
        stack = [...stack, ...neighbours(y, x)]
      }
    }
  }

  for (let j = 0; j < oct.length; j++) {
    for (let i = 0; i < oct[j].length; i++) {
      if (oct[j][i] === 9) oct[j][i] = 0
    }
  }

  for (let j = 0; j < oct.length; j++) {
    console.log(oct[j].join(''))
  }
  console.log('')

  return flashes
}

const p1 = (oct) => sim(oct, 2)

const oct = parse(input)
console.log(p1(oct))
