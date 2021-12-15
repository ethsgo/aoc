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

/// A min-heap.
function Heap(lessThan, equalEntry) {
  let items = []

  //      0
  //   1      2
  // 3  4   5   6
  const lix = (i) => 2 * i + 1
  const rix = (i) => 2 * (i + 1)
  const pix = (i) => Math.floor((i - 1) / 2)

  function swap(i, j) {
    const t = items[i]
    items[i] = items[j]
    items[j] = t
  }

  this.popMin = () => {
    const r = items[0]
    let i = 0
    items[0] = items.pop()
    while (i < items.length) {
      const li = lix(i)
      if (li >= items.length) {
        break
      }

      const ri = rix(i)
      if (ri >= items.length || lessThan(items[li], items[ri])) {
        if (lessThan(items[li], items[i])) {
          swap(i, li)
          i = li
        } else {
          break
        }
      } else {
        if (lessThan(items[ri], items[i])) {
          swap(i, ri)
          i = ri
        } else {
          break
        }
      }
    }
    return r
  }

  this.insertOrUpdate = (e) => {
    let i = 0
    while (i < items.length) {
      if (equalEntry(e, items[i])) {
        items[i] = e
        break
      }
      i++
    }
    if (i === items.length) {
      items.push(e)
    }
    while (i > 0 && lessThan(e, items[pix(i)])) {
      swap(i, pix(i))
      i = pix(i)
    }
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

  let lt = (e1, e2) => e1[2] < e2[2]
  let eqEntry = (e1, e2) => e1[0] === e2[0] && e1[1] === e2[1]
  let distanceHeap = new Heap(lt, eqEntry)

  for (const d of neighbours(0, 0, 0)) distanceHeap.insertOrUpdate(d)

  while (true) {
    let [x, y, w] = distanceHeap.popMin()
    if (x === ymax && y === xmax) return w
    for (const [r, s, t] of neighbours(x, y, w)) {
      if (visited.find((v) => v[0] === r && v[1] === s)) continue
      distanceHeap.insertOrUpdate([r, s, t])
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
