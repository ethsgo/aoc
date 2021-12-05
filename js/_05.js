const { utils } = require('ethers')

let input = `
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
`

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString()
}

function numbers(s) {
  return s
    .split(/[^\d.]+/)
    .filter((t) => t !== '')
    .map(Number)
}

function* chunks(xs, n) {
  for (let i = 0; i < xs.length; i += n) {
    yield xs.slice(i, i + n)
  }
}

function parse(input) {
  return [...chunks(numbers(input), 4)]
}

// line segments
let segments = parse(input)

function p1(segments) {
  // consider only horizontal or vertical line segments
  segments = segments.filter((s) => s[0] == s[2] || s[1] == s[3])

  const maxX = segments.reduce((a, s) => Math.max(a, s[0], s[2]), 0)
  const maxY = segments.reduce((a, s) => Math.max(a, s[1], s[3]), 0)

  const grid = [...Array(maxY + 1)].map((x) => Array(maxX + 1).fill(0))

  for (s of segments) {
    for (let x = Math.min(s[0], s[2]); x <= Math.max(s[0], s[2]); x++) {
      for (let y = Math.min(s[1], s[3]); y <= Math.max(s[1], s[3]); y++) {
        grid[y][x] += 1
      }
    }
    // console.log(grid.map(JSON.stringify))
  }

  return grid.flat().filter((x) => x > 1).length
}

function p2(input) {}

console.log(p1(segments))
// console.log(p2(input))
