let input = `
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
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

function split(xs) {
  for (let i = 0; i < xs.length; i++) {
    let [v, depth] = xs[i]
    if (v >= 10) {
      const xl = Math.floor(v / 2)
      const xr = Math.ceil(v / 2)
      xs[i] = [xl, depth + 1]
      xs.splice(i + 1, 0, [xr, depth + 1])
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

function magnitude(xs) {
  xs = [...xs]
  let i = 0
  while (true) {
    let [v, depth] = xs[i]
    if (i + 1 < xs.length) {
      let [nv, nd] = xs[i + 1]
      if (nd === depth) {
        xs[i] = [3 * v + 2 * nv, depth - 1]
        xs.splice(i + 1, 1)
        i = 0
      } else {
        i++
      }
    } else {
      return v
    }
  }
}

const sum = (xs) => xs.slice(1, xs.length).reduce(add, xs[0])

const p1 = (xs) => magnitude(sum(xs))

function p2(xs) {
  let maxm = 0
  for (let i = 0; i < xs.length; i++) {
    for (let j = 0; j < xs.length; j++) {
      if (i === j) continue
      const m = magnitude(add(xs[i], xs[j]))
      if (m > maxm) maxm = m
    }
  }
  return maxm
}

const ns = parse(input)
const xs = ns.map(linearize)
console.log(p1(xs))
console.log(p2(xs))
