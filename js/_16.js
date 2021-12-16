const inputLit = `
110100101111111000101000
`.trim()

const inputOpLen = `
00111000000000000110111101000101001010010001001000000000
`.trim()

const inputOpNum = `
11101110000000001101010000001100100000100011000001100000
`.trim()

const hexToBin = (s) =>
  s
    .split('')
    .map((c) => parseInt(c, 16).toString(2).padStart(4, 0))
    .join('')

const inputVsum16 = hexToBin('8A004A801A8002F478')
const inputVSum31 = hexToBin('A0016C880162017C3686B18A3D4780')

let input = inputVSum31

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
      packets.push(p.packet)
      i += p.length
    }
    return { operator: { id, packets }, length: i }
  } else {
    let n = decimal(b.slice(i, (i += 11)))
    let packets = []
    while (n > 0) {
      const p = packet(b.slice(i, b.length))
      packets.push(p.packet)
      i += p.length
      n--
    }
    return { operator: { id, packets }, length: i }
  }
}

function versionSum(p) {
  let c = p.version
  if (p.packets) {
    for (const x of p.packets) {
      c += versionSum(x)
    }
  }
  return c
}

const p1 = (b) => versionSum(packet(b).packet)

const bits = parse(input)
console.log(p1(bits))
