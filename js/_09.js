let input = `
2199943210
3987894921
9856789892
8767896789
9899965678
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split(/\s+/).map((s) => [...s].map(Number))

function lowPoints(heightmap) {
  function at(y, x) {
    if (y < 0 || y >= heightmap.length) return 10
    if (x < 0 || x >= heightmap[y].length) return 10
    return heightmap[y][x]
  }

  const neighbours = (y, x) => [
    at(y - 1, x),
    at(y, x + 1),
    at(y + 1, x),
    at(y, x - 1),
  ]

  return heightmap.flatMap((row, y) =>
    row
      .map((pt, x) => ({ x, y, pt }))
      .filter(({ x, y, pt }) => neighbours(y, x).every((v) => pt < v))
  )
}

const sum = (xs) => xs.reduce((a, x) => a + x, 0)
const p1 = (heightmap) => sum(lowPoints(heightmap).map(({ pt }) => pt + 1))

function p2(heightmap) {
  function at(y, x) {
    if (y < 0 || y >= heightmap.length) return 10
    if (x < 0 || x >= heightmap[y].length) return 10
    const r = heightmap[y][x]
    return r == -1 ? 10 : r
  }

  const next = (y, x, pt) => [
    { fy: y - 1, fx: x, from: pt },
    { fy: y, fx: x + 1, from: pt },
    { fy: y + 1, fx: x, from: pt },
    { fy: y, fx: x - 1, from: pt },
  ]

  const basinSizes = lowPoints(heightmap).map(({ x, y, pt }) => {
    let c = 1
    heightmap[y][x] = -1
    let frontier = next(y, x, pt)
    while (frontier.length > 0) {
      const { fy, fx, from } = frontier.pop()
      const fp = at(fy, fx)
      if (fp === -1 || fp === 9 || fp === 10 || fp < from) continue
      c++
      heightmap[fy][fx] = -1
      frontier = [...frontier, ...next(fy, fx, fp)]
    }
    return c
  })

  return basinSizes
    .sort((x, y) => y - x)
    .slice(0, 3)
    .reduce((a, x) => a * x, 1)
}

const heightmap = parse(input)
console.log(p1(heightmap))
console.log(p2(heightmap))
