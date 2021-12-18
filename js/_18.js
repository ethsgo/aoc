let input = `
[[[[4,3],4],4],[7,[[8,4],9]]]
[1,1]
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split('\n').map(JSON.parse)

function treeTop(n) {
  console.log(`before - ${JSON.stringify(n)}`)
  const m = tree({ n: n, depth: 0 }).v
  console.log(`after  - ${JSON.stringify(m)}`)
  console.log(`orignl - ${JSON.stringify(n)}`)
}

function tree({ n, depth, didExplode, debris }) {
  if (didExplode && !debris) return n
  if (typeof n === 'number') {
    if (typeof debris === 'number') {
      console.log(
        `depth ${depth} leaf - regular number - ${n} - debris ${debris}`
      )
      return { v: n + debris }
    } else {
      console.log(`depth ${depth} leaf - regular number - ${n}`)
      return { v: n }
    }
  } else {
    console.log(`depth ${depth} pair - ${JSON.stringify(n)}`)
    if (depth === 4) {
      console.log(`explode!`)
      return { v: 0, didExplode: true, debris: n[1] }
    } else {
      const l = tree({ n: n[0], depth: depth + 1, didExplode, debris })
      const r = tree({
        n: n[1],
        depth: depth + 1,
        didExplode: l.didExplode,
        debris: l.debris,
      })
      return { v: [l.v, r.v], didExplode: r.didExplode, debris: r.debris }
    }
  }
}

const p1 = (ns) => reduce

const ns = parse(input)
// console.log(p1(ns))
console.log(treeTop([[[[[9, 8], 1], 2], 3], 4]))
