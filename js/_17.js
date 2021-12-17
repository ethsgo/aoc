let input = 'target area: x=20..30, y=-10..-5'

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) =>
  input
    .split(/[^\d-]+/)
    .slice(1, 5)
    .map(Number)

function valid(t, v) {
  let p = [0, 0]
  let maxY = 0
  while (p[0] <= t[1] && p[1] >= t[2]) {
    p = [p[0] + v[0], p[1] + v[1]]
    v = [v[0] > 0 ? v[0] - 1 : v[0] < 0 ? v[0] + 1 : 0, v[1] - 1]
    maxY = Math.max(maxY, p[1])
    if (p[0] >= t[0] && p[0] <= t[1] && p[1] >= t[2] && p[1] <= t[3])
      return maxY
  }
  return 0
}

function validTrajectories(target) {
  let maxY = 0
  let c = 0
  for (let x = 0; x <= target[1]; x++) {
    for (let y = target[2]; y <= -target[2]; y++) {
      const v = [x, y]
      const ym = valid(ta, v)
      if (ym > 0) {
        c++
        if (ym > maxY) maxY = ym
      }
    }
  }
  return { maxY, count: c }
}

const target = parse(input)
const { maxY, count } = validTrajectories(target)
const p1 = maxY
const p2 = count

console.log(p1)
console.log(p2)
