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

function p1(heightmap) {
  function at(y, x) {
    if (y < 0 || y >= heightmap.length) return 10
    const row = heightmap[y]
    if (x < 0 || x >= row.length) return 10
    return row[x]
  }

  const neighbours = (y, x) => [
    at(y - 1, x),
    at(y, x + 1),
    at(y + 1, x),
    at(y, x - 1),
  ]

  return heightmap
    .map((row, y) =>
      row.filter((pt, x) => neighbours(y, x).every((v) => pt < v))
    )
    .flat()
    .flat()
    .map((x) => x + 1)
    .reduce((a, x) => a + x)
}

const p2 = 0

const heightmap = parse(input)
console.log(p1(heightmap))
// console.log(p2(entries))
