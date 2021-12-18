let input = `
[[[[4,3],4],4],[7,[[8,4],9]]]
[1,1]
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split('\n').map(JSON.parse)

function linearize(n) {
  function lin(n, depth) {
    if (typeof n === 'number') {
      return [[n, depth]]
    } else {
      const l = lin(n[0], depth + 1)
      const r = lin(n[1], depth + 1)
      return [...l, ...r]
    }
  }

  return lin(n, 0)
}

function explode(xs) {
  for (let i = 0; i < xs.length; i++) {
    let [v, depth] = xs[i]
    if (depth === 5) {
      const xl = xs[i][0]
      const xr = xs[i + 1][0]
      xs[i] = [0, 4]
      xs.splice(i + 1, 1)
      if (i > 0) xs[i - 1][0] += xl
      if (i + 1 < xs.length) xs[i + 1][0] += xr
      return true
    }
  }
  return false
}

function p1(ns) {
  const xs = linearize(ns)
  while (explode(xs)) {}
  return xs
}

const ns = parse(input)
// console.log(p1(ns))
// console.log(p1([[[[[9, 8], 1], 2], 3], 4]))
// console.log(p1([7,[6,[5,[4,[3,2]]]]]))
console.log(p1([[6, [5, [4, [3, 2]]]], 1]))
