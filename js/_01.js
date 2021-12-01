let xs = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

if (!process.stdin.isTTY) {
  const lines = require('fs').readFileSync(0).toString().split('\n')
  xs = lines.filter((x) => x.length > 0).map(Number)
}

function p1(xs) {
  let increases = 0
  // Assume 0 is not a valid depth
  let previous
  for (let i = 0; i < xs.length; i++) {
    if (previous && previous < xs[i]) {
      increases++
    }
    previous = xs[i]
  }
  return increases
}

function p2(xs) {
  let increases = 0
  // Need at least three samples
  if (xs.length < 3) return 0
  // Measurement window
  let ys = [xs[0], xs[1], 0]
  // Index into the measurement window
  let yi = 2
  // Assume 0 is not a valid sum
  let previousSum
  for (let i = 2; i < xs.length; i++) {
    ys[yi] = xs[i]
    yi = (yi + 1) % 3
    const sum = ys[0] + ys[1] + ys[2]
    if (previousSum && previousSum < sum) {
      increases++
    }
    previousSum = sum
  }
  return increases
}

console.log(p1(xs))
console.log(p2(xs))
