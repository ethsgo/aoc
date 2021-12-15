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

//      0
//   1      2
// 3  4   5   6
const lix = (i) => 2 * i + 1
const rix = (i) => 2 * (i + 1)

function swap(xs, i, j) {
  const t = xs[i]
  xs[i] = xs[j]
  xs[j] = t
}

const heapMin = (heap) => heap[0]

function heapPopMin(heap, lessThanEqual) {
  const r = heap[0]
  let i = 0
  while (i < heap.length) {
    const li = lix(i)
    if (li >= heap.length) {
      heap[i] = null
      break
    }
    const ri = rix(i)
    if (ri >= heap.length) {
      swap(heap, i, li)
      heap[li] = null
      break
    }
    if (lessThanEqual(heap[li], heap[ri])) {
      swap(heap, i, li)
      i = li
    } else {
      swap(heap, i, ri)
      i = ri
    }
  }
  return r
}

function heapInsertOrUpdate(heap, e, lessThanEqual) {
  
}



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

  let distances = neighbours(0, 0, 0).sort((u, v) => v[2] - u[2])
  let visited = [0, 0]

  let distanceHeap = []

  while (distances.length > 0) {
    let [x, y, w] = distances.pop()
    if (x === ymax && y === xmax) return w
    for (const [r, s, t] of neighbours(x, y, w)) {
      if (visited.find((v) => v[0] === r && v[1] === s)) continue
      let found = false
      for (let i = 0; i < distances.length; i++) {
        if (r === distances[i][0] && s === distances[i][1]) {
          if (w + t < distances[i][2]) {
            distances[i][2] = w + t
          }
          found = true
          break
        }
      }
      if (!found) {
        distances.push([r, s, t])
      }
      visited.push([r, s])
    }
    distances.sort((u, v) => v[2] - u[2])
  }
}

const g = parse(input)
console.log(p1(g))
