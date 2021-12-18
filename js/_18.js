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
      console.log('after explode', JSON.stringify(xs))
      return true
    }
  }
  return false
}

function split(xs) {
  for (let i = 0; i < xs.length; i++) {
    let [v, depth] = xs[i]
    if (v >= 10) {
      const xl = Math.floor(v / 2)
      const xr = Math.ceil(v / 2)
      xs[i] = [xl, depth + 1]
      xs.splice(i + 1, 0, [xr, depth + 1])
      console.log('after split', JSON.stringify(xs))
      return true
    }
  }
  return false
}

function join(xs, ys) {
  const deepen = (xs) => xs.map((e) => [e[0], e[1] + 1])
  return [...deepen(xs), ...deepen(ys)]
}

function add(xs, ys) {
  let zs = join(xs, ys)
  while (explode(zs) || split(zs)) {}
  return zs
}

function tree(xs) {
  let i = 0
  while (true) {
    let [v, depth] = xs[i]
    if (i + 1 < xs.length) {
      let [nv, nd] = xs[i + 1]
      if (nd === depth) {
        xs[i] = [[v, nv], depth - 1]
        xs.splice(i + 1, 1)
        i = 0
      } else {
        i++
      }
    } else {
      console.log(xs)
      return v
    }
  }
}

function magnitude(xs) {
  function m(t) {
    if (typeof t === 'number') return t
    return 3 * m(t[0]) + 2 * m(t[1])
  }
  const t = tree(xs)
  console.log(t)
  return m(t)
}

function p1(ns) {
  const ls = ns.map(linearize)
  const sum = ls.slice(1, ls.length).reduce(add, ls[0])
  return magnitude(sum)
}

const ns = parse(input)
// console.log(p1(ns))
// console.log(p1([[[[[9, 8], 1], 2], 3], 4]))
// console.log(JSON.stringify(tree(linearize([[[[[9, 8], 1], 2], 3], 4]))))
// console.log(p1([7,[6,[5,[4,[3,2]]]]]))
// console.log(p1([[6, [5, [4, [3, 2]]]], 1]))
// prettier-ignore
// console.log(magnitude(linearize([9,1])))
// prettier-ignore
// console.log(magnitude(linearize([[9,1],[1,9]])))
// prettier-ignore
console.log(magnitude(linearize([[1,2],[[3,4],5]])))

// prettier-ignore
console.log(magnitude(linearize([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]])))
// console.log(p1(ns))
