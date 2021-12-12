let input = `
start-A
start-b
A-c
A-b
b-d
A-end
b-end
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
  let visited = new Set()
  let frontier = ['start']
  let parent = {};
  while (frontier.length > 0) {
    const u = frontier.shift()
    console.log('visit', u)
    // If we're visiting a lowercase place, mark it as done.
    if (u === u.toLowerCase()) visited.add(u)
    // Where can we go next
    const next = links.filter((link) => link[0] === u).map((link) => link[1])
    for (const v of next) {
      // Ignore places where we don't want to go to again
      if (visited.has(v)) continue
      let px = (parent[v] ?? [])
      px.push(u)
      parent[v] = px
      frontier.push(v)
    }
  }
  return parent
}

console.log(p1(parse(input)))
