let input = 'target area: x=20..30, y=-10..-5'

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) =>
  input
    .split(/[^\d-]+/)
    .slice(1, 5)
    .map(Number)

// ta: target area
function trajectoryWithMaxY(ta) {
  let v = [7, 2]
  let p = [0, 0]
  while (p[0] <= ta[1] && p[1] >= ta[2]) {
    console.log(p)
    const np = [p[0] + v[0], p[1] + v[1]]
    if (np[0] >= ta[0] && np[0] <= ta[1] && np[1] >= ta[2] && np[1] <= ta[3])
      return true
    p = np
    v = [v[0] > 0 ? v[0] - 1 : v[0] < 0 ? v[0] + 1 : 0, v[1] - 1]
  }
  return false
}

const p1 = (ta) => trajectoryWithMaxY(ta)

const ta = parse(input)
console.log(p1(ta))
