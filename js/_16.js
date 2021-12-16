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
    const p = literal(b.slice(i, b.length))
    return {
      packet: { version: v, type: t, literal: p.literal },
      length: p.length + i,
    }
  } else {
    const p = operator(b.slice(i, b.length))
    return {
      packet: { version: v, type: t, ...p.operator },
      length: p.length + i,
    }
  }
}

function literal(b) {
  let i = 0
  let more = true
  let lit = 0
  while (more) {
    lit = (lit << 4) + decimal(b.slice(i + 1, i + 1 + 4))
    more = b[i] === '1'
    i += 5
  }
  return { literal: lit, length: i }
}

function operator(b) {
  let i = 0
  let id = b[i++] === '0' ? 0 : 1
  if (id === 0) {
    let len = decimal(b.slice(i, (i += 15)))
    let end = i + len
    let packets = []
    while (i < end) {
      const p = packet(b.slice(i, b.length))
      console.log(p)
      packets.push(p.packet)
      i += p.length
    }
    return { operator: { id, packets }, length: i }
  }
  return id
}

const p1 = (b) => packet(b)

const bits = parse(input)
console.log(p1(bits))
