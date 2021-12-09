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

  return heightmap
    .map((row, y) => {
      return row.map((pt, x) => {
        if (
          [at(y - 1, x), at(y, x + 1), at(y + 1, x), at(y, x - 1)].every(
            (v) => row[x] < v
          )
        ) {
          // console.log(pt, [at(y - 1, x), at(y, x + 1), at(y + 1, x), at(y, x - 1)])
          return [pt]
        }
        return []
      })
    })
    .flat()
    .flat()
}

const p2 = 0

const heightmap = parse(input)
console.log(p1(heightmap))
// console.log(p2(entries))
