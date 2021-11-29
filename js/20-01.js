let xs = [1721, 979, 366, 299, 675, 1456]

if (!process.stdin.isTTY) {
  const lines = require('fs').readFileSync(0).toString().split('\n')
  xs = lines.map((s) => parseInt(s)).filter((x) => x)
}

function p1(xs) {
  for (let i = 0; i < xs.length; i++) {
    for (let j = i + 1; j < xs.length; j++) {
      if (xs[i] + xs[j] === 2020) {
        return xs[i] * xs[j]
      }
    }
  }
}

function p2(xs) {
  const m = new Map(xs.map((x) => [x, true]))
  console.log(m)
  for (let i = 0; i < xs.length; i++) {
    for (let j = i + 1; j < xs.length; j++) {
      const xk = 2020 - (xs[i] + xs[j])
      if (m.get(xk)) {
        return xs[i] * xs[j] * xk
      }
    }
  }
}

console.log(p1(xs))
console.log(p2(xs))
