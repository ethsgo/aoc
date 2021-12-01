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

console.log(p1(xs))
