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

const parse = (input) => input.split(/\s+/).map((s) => s.split('-'))

function p1(links) {
  const next = (u) => [
    ...links.filter((link) => link[0] === u).map((link) => link[1]),
    ...links.filter((link) => link[1] === u).map((link) => link[0]),
  ]

  let frontier = [{ u: 'start', visited: [] }]
  let nPaths = 0

  while (frontier.length > 0) {
    let { u, visited } = frontier.shift()

    visited = [...visited]
    if (u === u.toLowerCase()) visited.push(u)

    for (const v of next(u)) {
      if (visited.includes(v)) continue
      if (v === 'end') {
        nPaths++
      } else {
        frontier.push({ u: v, visited: visited })
      }
    }
  }

  return nPaths
}

console.log(p1(parse(input)))
