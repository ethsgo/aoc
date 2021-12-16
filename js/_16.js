let input = '8A004A801A8002F478'

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) =>
  input
    .split('')
    .flatMap((c) => parseInt(c, 16).toString(2).padStart(4, 0).split(''))

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

function eval(p) {
  const [u, v] = p.packets ?? []
  switch (p.type) {
    case 0:
      return v ? eval(u) + eval(v) : eval(u)
    case 1:
      return v ? eval(u) * eval(v) : eval(u)
    case 2:
      return Math.min(...p.packets.map(eval))
    case 3:
      return Math.max(...p.packets.map(eval))
    case 4:
      return p.literal
    case 5:
      return eval(u) > eval(v) ? 1 : 0
    case 6:
      return eval(u) < eval(v) ? 1 : 0
    case 7:
      return eval(u) === eval(v) ? 1 : 0
    }
}

const p1 = versionSum
const p2 = eval

const bits = parse(input)
const pkt = packet(bits).packet
console.log(p1(pkt))
console.log(p2(pkt))
