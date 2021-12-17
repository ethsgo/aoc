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
  return ta
}

const p1 = (ta) => trajectoryWithMaxY(ta)

const ta = parse(input)
console.log(p1(ta))
