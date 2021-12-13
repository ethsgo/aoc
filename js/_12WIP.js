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
  let edges = {}

  let k = 2
  let z = {}
  z['start'] = 0
  z['end'] = 1
  for (let [u, v] of data) {
    if (!(u in z)) {
      if (u.toUpperCase() === u) large.add(u)
      z[u] = k
      u = k
      k++
    } else {
      u = z[u]
    }

    if (!(v in z)) {
      if (v.toUpperCase() === v) large.add(v)
      z[v] = k
      v = k
      k++
    } else {
      v = z[v]
    }

    if (!(u in edges)) edges[u] = []
    if (v !== 0) edges[u].push(v)

    if (!(v in edges)) edges[v] = []
    if (u !== 0) edges[v].push(u)
  }

  let edges2 = {}
  for (const u in edges) {
    if (large.has(u)) continue
    edges2[u] = {}
    for (const v in edges[u]) {
      if (large.has(v)) {
        for (const w in edges[v]) {
          if (w in edges2[u]) {
            edges2[u][w]++
          } else {
            edges2[u][w] = 1
          }
        }
      } else {
        if (v in edges2[u]) {
          edges2[u][v]++
        } else {
          edges2[u][v] = 1
        }
      }
    }
  }

  edges = edges2

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
