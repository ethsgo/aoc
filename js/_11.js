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
  function neighbours(y, x) {
    let result = []
    for (let dy of [-1, 0, 1]) {
      for (let dx of [-1, 0, 1]) {
        if (dy === 0 && dx === 0) continue
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
      if (oct[j][i] > 9) {
        flashes++
        oct[j][i] = 0
        let stack = neighbours(j, i)
        while (stack.length > 0) {
          let [y, x] = stack.pop()
          if (oct[y][x] === 0) continue
          oct[y][x]++
          if (oct[y][x] > 9) {
            flashes++
            oct[y][x] = 0
            stack = [...stack, ...neighbours(y, x)]
          }
        }
      }
    }
  }

  // for (let j = 0; j < oct.length; j++) {
  //   for (let i = 0; i < oct[j].length; i++) {
  //     if (oct[j][i] > 9) oct[j][i] = 0
  //   }
  // }

  for (let j = 0; j < oct.length; j++) {
    console.log(oct[j].join(''))
  }
  console.log(flashes)

  return flashes
}

const p1 = (oct) => sim(oct, 2)

const oct = parse(input)
console.log(p1(oct))
