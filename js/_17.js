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
function valid(ta, v) {
  let p = [0, 0]
  let ymax = 0
  while (p[0] <= ta[1] && p[1] >= ta[2]) {
    // console.log(p)
    const np = [p[0] + v[0], p[1] + v[1]]
    if (np[0] >= ta[0] && np[0] <= ta[1] && np[1] >= ta[2] && np[1] <= ta[3])
      return { hit: true, ymax }
    ymax = Math.max(ymax, p[1])
    p = np
    v = [v[0] > 0 ? v[0] - 1 : v[0] < 0 ? v[0] + 1 : 0, v[1] - 1]
  }
  return { hit: false, ymax }
}

function trajectoryWithMaxY(ta) {
  // let v = [7, 2]
  // let v = [6, 3]
  // let v = [9, 0]
  // let v = [17, -4]
  let r = 0
  let yr = Math.abs(ta[2])
  for (let x = 0; x <= ta[1]; x++) {
    for (let y = -yr; y <= yr; y++) {
      const v = [x, y]
      const { hit, ymax } = valid(ta, v)
      // console.log(v, hit, ymax)
      if (hit && ymax > r) r = ymax
    }
  }
  return r
}

const p1 = (ta) => trajectoryWithMaxY(ta)

const ta = parse(input)
console.log(p1(ta))
