const path = require('path')

let input = `
start-A
start-b
A-c
A-b
b-d
A-end
b-end
`.trim()

let inputM = `
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
`.trim()

let inputL = `
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const data = input.split('\n').map((s) => s.split('-'))

// From https://gist.github.com/zootos/148f1097027c66849b7bf1c02a711bf4
function solve(data) {
  let large = new Set()
  let edges = new Map()

  let k = 2
  let z = new Map()
  z.set('start', 0)
  z.set('end', 1)
  for (let [u, v] of data) {
    if (!z.has(u)) {
      if (u.toUpperCase() === u) large.add(k)
      z.set(u, k)
      u = k
      k++
    } else {
      u = z.get(u)
    }

    if (!z.has(v)) {
      if (v.toUpperCase() === v) large.add(k)
      z.set(v, k)
      v = k
      k++
    } else {
      v = z.get(v)
    }

    if (!edges.has(u)) edges.set(u, [])
    if (v !== 0) edges.get(u).push(v)

    if (!edges.has(v)) edges.set(v, [])
    if (u !== 0) edges.get(v).push(u)
  }

  console.log(z)
  // console.log(edges)
  // console.log(large)

  let edges2 = new Map()

  for (const u of edges.keys()) {
    if (large.has(u)) continue
    edges2.set(u, new Map())
    for (const v of edges.get(u)) {
      if (large.has(v)) {
        for (const w of edges.get(v)) {
          edges2.get(u).set(w, (edges2.get(u).get(w) ?? 0) + 1)
        }
      } else {
        for (const v of edges.get(u)) {
          edges2.get(u).set(v, (edges2.get(u).get(v) ?? 0) + 1)
        }
      }
    }
  }

  edges = edges2

  return edges

  total = 0
  s = [{ u: 0, k: 1, path: [], twice: false }]

  console.log(edges)
  while (s.length > 0) {
    let { u, k, path, twice } = s.pop()
    console.log({ u, k, path, twice })
    path = [...path, u]
    for (const v in edges[u]) {
      console.log(v)
      if (v === 1) {
        total += k * edges[u][v]
        continue
      }
      if (twice || !path.includes(v)) {
        s.push({ u: v, k: k * edges[u][v], path, twice })
      }
    }
  }

  return total
}

console.log(solve(data))
