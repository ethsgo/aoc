let xs = [
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

function p1(xs) {
  let [x, y] = [0, 0]
  // Make sure that input consists of pairs.
  if (xs.length % 2) return 0
  for (let i = 0; i < xs.length; i += 2) {
    const d = Number(xs[i + 1])
    switch (xs[i]) {
      case 'forward':
        x += d
        break
      case 'up':
        y -= d
        break
      case 'down':
        y += d
        break
    }
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

console.log(p1(xs))
// console.log(p2(xs))
