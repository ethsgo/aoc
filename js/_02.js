let tokens = [
  'forward',
  5,
  'down',
  5,
  'forward',
  8,
  'up',
  3,
  'down',
  8,
  'forward',
  2,
]

if (!process.stdin.isTTY) {
  tokens = require('fs').readFileSync(0).toString().split(/\s+/)
  tokens = tokens.filter((t) => t.length > 0)
}

/// Parse the input into [dx, dy] pairs
function parseDxDy(tokens) {
  let dxdy = []
  // Make sure that input consists of pairs.
  if (tokens.length % 2) return 0
  for (let i = 0; i < tokens.length; i += 2) {
    const d = Number(tokens[i + 1])
    switch (tokens[i]) {
      case 'forward':
        dxdy.push([d, 0])
        break
      case 'up':
        dxdy.push([0, -d])
        break
      case 'down':
        dxdy.push([0, d])
        break
    }
  }
  return dxdy
}

function p1(dxdy) {
  let [x, y] = [0, 0]
  for (let i = 0; i < dxdy.length; i += 1) {
    x += dxdy[i][0]
    y += dxdy[i][1]
  }
  return x * y
}

function p2(dxdy) {
  let [x, y, aim] = [0, 0, 0]
  for (let i = 0; i < dxdy.length; i += 1) {
    aim += dxdy[i][1]
    x += dxdy[i][0]
    y += (dxdy[i][0] * aim)
  }
  return x * y
}

const dxdy = parseDxDy(tokens)
console.log(p1(dxdy))
console.log(p2(dxdy))
