let xs = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

if (!process.stdin.isTTY) {
  const lines = require('fs').readFileSync(0).toString().split('\n')
  xs = lines.filter((x) => x.length > 0).map(Number)
}

/// Return the number of changes in xs that are greater than the previous value.
function p1(xs) {
  let increases = 0
  for (let i = 1; i < xs.length; i++) {
    if (xs[i - 1] < xs[i]) {
      increases++
    }
  }
  return increases
}

function p2(xs) {
  let increases = 0
  // Need at least three samples
  if (xs.length < 3) return 0
  let previousSum = xs[0] + xs[1] + xs[2]
  for (let i = 3; i < xs.length; i++) {
    const sum = previousSum - xs[i - 3] + xs[i]
    if (previousSum < sum) {
      increases++
    }
    previousSum = sum
  }
  return increases
}

console.log(p1(xs))
console.log(p2(xs))
