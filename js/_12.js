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

function p1a(links) {
  let paths = new Set([['start']])
  let c = 0
  while (links.length > 0 && c++ < 5) {
    console.log({ paths })
    const heres = [...new Set([...paths].map((path) => path[path.length - 1]))]
    for (const here of heres) {
      console.log('here:', here)
      const linksFromHere = links.filter((l) => l[0] === here)
      console.log('linksFromHere:', linksFromHere)
      links = links.filter(
        (l) => !(l[0] === here && here.toUpperCase() !== here)
      )
      console.log('remaining links:', links)
      let newPaths = []
      for (const l of linksFromHere) {
        for (const path of paths) {
          if (path[path.length - 1] === here) {
            newPaths.push([...path, l[1]])
          }
        }
      }
      console.log('newPaths:', newPaths)
      for (const path of newPaths) {
        paths.add(path)
      }
    }
  }
  return paths
}

function p1(links) {
  // let visited = new Set()
  let frontier = [{ u: 'start', visited: new Set(), paths: [[]] }]
  let parent = {}
  // let paths = [['start']]
  let endedPaths = []
  let allPaths = []
  while (frontier.length > 0) {
    let { u, visited, paths } = frontier.shift()
    visited = new Set(visited)
    paths = [...paths].map((path) => [...path, u])
    allPaths = [...allPaths, ...paths]
    // console.log({ allPaths })

    // console.log('visit', u)
    // If we're visiting a lowercase place, mark it as done.
    if (u === u.toLowerCase()) visited.add(u)
    // Where can we go next
    const next = [
      ...links.filter((link) => link[0] === u).map((link) => link[1]),
      ...links.filter((link) => link[1] === u).map((link) => link[0]),
    ]
    // console.log({ u, visited, next, paths })
    // console.log({ next })
    for (const v of next) {
      // Ignore places where we don't want to go to again
      if (visited.has(v) && v !== 'end') continue
      let px = parent[v] ?? []
      px.push(u)
      parent[v] = px
      let newPaths = []
      // for (const path of paths) {
      //   console.log({ path: path.join(','), u })
      //   if (path[path.length - 1] === u) newPaths.push([...path, v])
      // }
      // paths = [...paths, ...newPaths]
      if (v === 'end') {
        endedPaths = [...endedPaths, ...paths.map((path) => [...path, 'end'])]
      } else {
        // console.log({ v })
        frontier.push({ u: v, visited: new Set(visited), paths: [...paths] })
      }
    }
    // console.log({ frontier })
    // paths = [...new Set(paths)]
    // console.log({ frontier })
    // console.log({ paths })
  }
  let paths = endedPaths
  // paths = paths.filter((path) => path[path.length - 1] === 'end')

  let spx = paths.map((path) => path.join(','))
  let uniqPaths = [...new Set(spx)].sort()
  // console.log(uniqPaths)
  return uniqPaths.length
}

console.log(p1(parse(input)))
