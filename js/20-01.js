let xs = [1721, 979, 366, 299, 675, 1456]

if (!process.stdin.isTTY) {
  const lines = require('fs').readFileSync(0).toString().split('\n')
  xs = lines.map((s) => parseInt(s)).filter((x) => x)
}

for (let i = 0; i < xs.length; i++) {
  for (let j = i + 1; j < xs.length; j++) {
    if (xs[i] + xs[j] === 2020) {
      console.log(xs[i] * xs[j])
    }
  }
}