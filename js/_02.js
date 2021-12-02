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

// if (!process.stdin.isTTY) {
//   const lines = require('fs').readFileSync(0).toString().split('\n')
//   xs = lines.filter((x) => x.length > 0).map(Number)
// }

// Parse the input into [dx, dy] pairs
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

function p2(xs) {
  let increases = 0
  // Need at least three samples.
  if (xs.length < 3) return 0
  for (let i = 3; i < xs.length; i++) {
    // Only the extreme values differ in the previous and this measurement window.
    if (xs[i - 3] < xs[i]) {
      increases++
    }
  }
  return increases
}

const dxdy = parseDxDy(tokens)
console.log(p1(dxdy))
// console.log(p2(xs))
