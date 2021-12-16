let input = `
110100101111111000101000
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) =>
  input
    .split('\n')
    .map((s) => s.split(''))
    .flat()

function decimal(b) {
  let r = 0
  for (const c of b) {
    r *= 2
    if (c === '1') r += 1
  }
  return r
}

function packet(b) {
  let i = 0
  const v = decimal(b.slice(i, (i += 3)))
  const t = decimal(b.slice(i, (i += 3)))
  if (t === 4) {
    let lit = 0
    let more = true
    while (more) {
      console.log(i)
      console.log(b.slice(i + 1, i + 1 + 4))
      console.log(decimal(b.slice(i + 1, i + 1 + 4)))
      lit = (lit << 4) + decimal(b.slice(i + 1, i + 1 + 4))
      more = b[i] === '1'
      i += 5
    }
    return { version: v, type: t, literal: lit }
  } else {
    return { version: v, type: t, operator: operator(b.slice(i, b.length)) }
  }
}

function operator(b) {}

const p1 = (b) => packet(b)
const p2 = (g) => shortestPath(expand(g))

const bits = parse(input)
console.log(p1(bits))
// console.log(p2(g))
