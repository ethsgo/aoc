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

//      0
//   1      2
// 3  4   5   6
const lix = (i) => 2 * i + 1
const rix = (i) => 2 * (i + 1)
const pix = (i) => Math.floor((i - 1) / 2)

function swap(xs, i, j) {
  const t = xs[i]
  xs[i] = xs[j]
  xs[j] = t
}

function heapPopMin(heap, lessThan, equalEntry) {
  const r = heap[0]
  let i = 0
  heap[0] = heap.pop()
  while (i < heap.length) {
    const li = lix(i)
    if (li >= heap.length) {
      break
    }

    const ri = rix(i)
    if (ri >= heap.length || lessThan(heap[li], heap[ri])) {
      if (lessThan(heap[li], heap[i])) {
        swap(heap, i, li)
        i = li
      } else {
        break
      }
    } else {
      if (lessThan(heap[ri], heap[i])) {
        swap(heap, i, ri)
        i = ri
      } else {
        break
      }
    }
  }
  return r
}

function heapInsertOrUpdate(heap, e, lessThan, equalEntry) {
  let i = 0
  while (i < heap.length) {
    if (equalEntry(e, heap[i])) {
      heap[i] = e
      break
    }
    i++
  }
  if (i === heap.length) {
    heap.push(e)
  }
  while (i > 0 && lessThan(e, heap[pix(i)])) {
    swap(heap, i, pix(i))
    i = pix(i)
  }
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

  let visited = [0, 0]

  let distanceHeap = []
  let lt = (e1, e2) => e1[2] < e2[2]
  let eqEntry = (e1, e2) => e1[0] === e2[0] && e1[1] === e2[1]

  for (const d of neighbours(0, 0, 0))
    heapInsertOrUpdate(distanceHeap, d, lt, eqEntry)

  while (true) {
    let [x, y, w] = heapPopMin(distanceHeap, lt, eqEntry)
    if (x === ymax && y === xmax) return w
    for (const [r, s, t] of neighbours(x, y, w)) {
      if (visited.find((v) => v[0] === r && v[1] === s)) continue
      heapInsertOrUpdate(distanceHeap, [r, s, t], lt, eqEntry)
      visited.push([r, s])
    }
  }
}

function expand(g) {
  const wrap = (i) => (i > 9 ? i % 9 : i)
  const inc = (i) => (w) => wrap(w + i)
  const five = [...Array(5)].map((_, i) => i)
  const topTiles = g.map((row) => five.map((i) => row.map(inc(i))).flat())
  return five.flatMap((i) => topTiles.map((row) => row.map(inc(i))))
}
const p1 = (g) => shortestPath(g)
const p2 = (g) => shortestPath(expand(g))

const g = parse(input)
console.log(p1(g))
console.log(p2(g))
