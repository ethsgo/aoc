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

// parse line segments
function parse(input) {
  return [...chunks(numbers(input), 4)]
}

function makeGrid(segments) {
  const maxX = segments.reduce((a, s) => Math.max(a, s[0], s[2]), 0)
  const maxY = segments.reduce((a, s) => Math.max(a, s[1], s[3]), 0)

  return [...Array(maxY + 1)].map((x) => Array(maxX + 1).fill(0))
}

function countOverlap(grid) {
  return grid.flat().filter((x) => x > 1).length
}

function p1(segments) {
  // consider only horizontal or vertical line segments
  segments = segments.filter((s) => s[0] == s[2] || s[1] == s[3])

  const grid = makeGrid(segments)

  for (s of segments) {
    for (let x = Math.min(s[0], s[2]); x <= Math.max(s[0], s[2]); x++) {
      for (let y = Math.min(s[1], s[3]); y <= Math.max(s[1], s[3]); y++) {
        grid[y][x] += 1
      }
    }
    // console.log(grid.map(JSON.stringify))
  }

  return countOverlap(grid)
}

function p2(segments) {
  segments = segments.filter((s) => s[0] == s[2] || s[1] == s[3])

  const grid = makeGrid(segments)

  for (s of segments) {
    const p0 = [s[0], s[1]]
    const p1 = [s[2], s[3]]

    let dx = p1[0] - p0[0]
    let dy = p1[1] - p0[1]

    // console.log(s, p0, p1, dx, dy)

    if (dx === 0) {
      const x = p0[0]
      let y = p0[1]
      dy = dy < 0 ? -1 : 1
      while (y != p1[1]) {
        grid[y][x] += 1
        y += dy
      }
      grid[y][x] += 1
    } else if (dy === 0) {
      const y = p0[1]
      let x = p0[0]
      dx = dx < 0 ? -1 : 1
      while (x != p1[0]) {
        grid[y][x] += 1
        x += dx
      }
      grid[y][x] += 1
    }

    console.log(grid.map(JSON.stringify))
  }

  return countOverlap(grid)
}

let segments = parse(input)
console.log(p1(segments))
console.log(p2(segments))
