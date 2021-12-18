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
  const m = tree(n, 0)
  console.log(`after  - ${JSON.stringify(m)}`)
  console.log(`orignl - ${JSON.stringify(n)}`)
}

function tree(n, depth) {
  if (typeof n === 'number') {
    console.log(`depth ${depth} leaf - regular number - ${n}`)
    return n
  } else {
    console.log(`depth ${depth} pair - ${JSON.stringify(n)}`)
    if (depth === 4) {
      console.log(`explode!`)
      return 0
    } else {
      const l = tree(n[0], depth + 1)
      const r = tree(n[1], depth + 1)
      return [l, r]
    }
  }
}

const p1 = (ns) => reduce

const ns = parse(input)
// console.log(p1(ns))
console.log(treeTop([[[[[9, 8], 1], 2], 3], 4]))
