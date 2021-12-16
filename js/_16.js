const inputLit = `
110100101111111000101000
`.trim()

const inputOpLen = `
00111000000000000110111101000101001010010001001000000000
`.trim()

let input = inputOpLen

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) =>
  input
    .split('\n')
    .map((s) => s.split(''))
    .flat()

function pdecimal(b) {
  let r = 0
  for (const c of b) {
    r *= 2
    if (c === '1') r += 1
  }
  return r
}

function ppacket(b) {
  let i = 0
  const version = pdecimal(b.slice(i, (i += 3)))
  const type = pdecimal(b.slice(i, (i += 3)))
  if (type === 4) {
    let { literal, length } = pliteral(b.slice(i, b.length))
    return { packet: { version, type, literal }, length }
  } else {
    let { operator, length } = poperator(b.slice(i, b.length))
    return { packet: { version, type, ...operator }, length }
  }
}

function pliteral(b) {
  let i = 0
  let more = true
  let lit = 0
  while (more) {
    lit = (lit << 4) + pdecimal(b.slice(i + 1, i + 1 + 4))
    more = b[i] === '1'
    i += 5
  }
  return { literal: lit, length: i }
}

function poperator(b) {
  let i = 0
  let id = b[i++] === '0' ? 0 : 1
  if (id === 0) {
    let len = pdecimal(b.slice(i, (i += 15)))
    let packets = []
    while (i < len) {
      let { packet, length } = ppacket(b.slice(i, b.length))
      console.log('.', packet, length)
      packets.push(packet)
      i += length
    }
    return { operator: { id, packets }, length: i }
  }
  return id
}

const p1 = (b) => ppacket(b)
const p2 = (g) => shortestPath(expand(g))

const bits = parse(input)
console.log(p1(bits))
// console.log(p2(g))
