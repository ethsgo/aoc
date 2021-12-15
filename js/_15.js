let input = `
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split('\n').map((s) => s.split('').map(Number))

const p1 = (g) => shortestPath(g)

function shortestPath(g) {
  const ymax = g.length - 1
  const xmax = g[ymax].length - 1

  const neighbours = (x, y, w) =>
    [
      [x + 1, y],
      [x - 1, y],
      [x, y + 1],
      [x, y - 1],
    ]
      .filter(([r, s]) => r >= 0 && s >= 0 && r <= xmax && s <= ymax)
      .map(([x, y]) => [x, y, w + g[y][x]])

  let distances = neighbours(0, 0, 0).sort((u, v) => u[2] - v[2])

  while (distances.length > 0) {
    let [x, y, w] = distances.pop()
    console.log([x, y, w])
    if (x === ymax && y === xmax) return w
  }
}

const g = parse(input)
console.log(p1(g))
