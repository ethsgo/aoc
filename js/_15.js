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
class Heap {
  constructor(keyLessThan, equalEntry) {
    this.lessThan = keyLessThan
    this.equalEntry = equalEntry
    this.items = []
  }

  //      0
  //   1      2
  // 3  4   5   6
  #lix = (i) => 2 * i + 1
  #rix = (i) => 2 * (i + 1)
  #pix = (i) => Math.floor((i - 1) / 2)

  #swap(i, j) {
    const t = this.items[i]
    this.items[i] = this.items[j]
    this.items[j] = t
  }

  popMin() {
    const r = this.items[0]
    let i = 0
    this.items[0] = this.items.pop()
    while (i < this.items.length) {
      const li = this.#lix(i)
      if (li >= this.items.length) {
        break
      }

      const ri = this.#rix(i)
      if (
        ri >= this.items.length ||
        this.lessThan(this.items[li], this.items[ri])
      ) {
        if (this.lessThan(this.items[li], this.items[i])) {
          this.#swap(i, li)
          i = li
        } else {
          break
        }
      } else {
        if (this.lessThan(this.items[ri], this.items[i])) {
          this.#swap(i, ri)
          i = ri
        } else {
          break
        }
      }
    }
    return r
  }

  insertOrUpdate(e) {
    let i = 0
    while (i < this.items.length) {
      if (this.equalEntry(e, this.items[i])) {
        this.items[i] = e
        break
      }
      i++
    }
    if (i === this.items.length) {
      this.items.push(e)
    }
    while (i > 0 && this.lessThan(e, this.items[this.#pix(i)])) {
      this.#swap(i, this.#pix(i))
      i = this.#pix(i)
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
