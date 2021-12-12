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

function paths(links, { allowOneSmallCave } = {}) {
  const next = (u) => [
    ...links.filter((link) => link[0] === u).map((link) => link[1]),
    ...links.filter((link) => link[1] === u).map((link) => link[0]),
  ]

  let frontier = [{ u: 'start', visited: [], smallCave: false, path: [] }]
  let p = 0

  while (frontier.length > 0) {
    let { u, visited, smallCave, path } = frontier.shift()

    let newVisited = [...visited]
    if (u === u.toLowerCase()) newVisited.push(u)

    path = [...path, u]

    for (const v of next(u)) {
      if (v === 'end') {
        // console.log([...path, v].join(','))
        p++
      } else {
        if (visited.includes(v)) {
          if (allowOneSmallCave && !smallCave && v !== 'start') {
            frontier.push({ u: v, visited, smallCave: v, path })
          }
        } else {
          frontier.push({ u: v, visited: newVisited, smallCave, path })
        }
      }
    }
  }

  return p
}

const p1 = (links) => paths(links)
const p2 = (links) => paths(links, { allowOneSmallCave: true })

// console.log(p1(parse(input)))
console.log(p2(parse(inputM)))
