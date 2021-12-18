let input = `
[[[[4,3],4],4],[7,[[8,4],9]]]
[1,1]
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split('\n').map(JSON.parse)

function linearize(n) {
  return lin(n, 0)
}

function lin(n, depth) {
  if (typeof n === 'number') {
    return [[n, depth]]
  } else {
    const l = lin(n[0], depth + 1)
    const r = lin(n[1], depth + 1)
    return [...l, ...r]
  }
}

function explode(xs) {
  for (let i = 0; i < xs.length; ) {
    let [v, depth] = xs[i]
    if (depth === 5) {
      xs[i] = [0, 4]
      xs.splice(i + 1, 1)
      i++
    } else {
      i++
    }
  }
}

function p1(ns) {
  const xs = linearize(ns)
  explode(xs)
  return xs
}

const ns = parse(input)
// console.log(p1(ns))
console.log(p1([[[[[9, 8], 1], 2], 3], 4]))
