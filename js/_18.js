let input = `
[[[[4,3],4],4],[7,[[8,4],9]]]
[1,1]
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split('\n').map(JSON.parse)

function linearize(n) {
  return lin(n, 0)
}

function lin(n, depth) {
  if (typeof n === 'number') {
    return [[n, depth]]
  } else {
    const l = lin(n[0], depth + 1)
    const r = lin(n[1], depth + 1)
    return [...l, ...r]
  }
}

function treeTop(n) {
  return tree(n, 0)
}

function tree(n, depth) {
  if (typeof n === 'number') {
    console.log(`depth ${depth} leaf - regular number - ${n}`)
    return [[n, depth]]
  } else {
    console.log(`depth ${depth} pair - ${JSON.stringify(n)}`)
    if (depth === 40) {
      console.log(`explode!`)
      return 0
    } else {
      const l = tree(n[0], depth + 1)
      const r = tree(n[1], depth + 1)
      return [...l, ...r]
    }
  }
}

const p1 = (ns) => reduce

const ns = parse(input)
// console.log(p1(ns))
console.log(linearize([[[[[9, 8], 1], 2], 3], 4]))
