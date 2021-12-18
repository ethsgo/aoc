let input = `
[[[[4,3],4],4],[7,[[8,4],9]]]
[1,1]
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split('\n').map(JSON.parse)

function linearize(n) {
  let prev
  let depth = 1
  let stack = [[n, 0]]
  let r = []
  while (stack.length > 0) {
    let (i, m) = stack.pop()
    for (; i < m.length; i++) {
      if (typeof m[i] === 'number') {
        r.push(m[i])
      }
    }
  }
}

function tree(n) {
  if (typeof n === 'number') {
    console.log('leaf - regular number -', n)
  } else {
    console.log('pair -', n)
    tree(n[0])
    tree(n[1])
  }
}

function reduce(n) {
  let prev
  let depth
  let actions

  return explode(n, null, 0)
}

function explode(n, prev, depth) {
  if (depth === 4 && typeof n !== 'number') {
return true
  } else {
    explode(n)
  }
  return n.length + prev
}

const p1 = (ns) => reduce

const ns = parse(input)
// console.log(p1(ns))
console.log(tree([[[[[9, 8], 1], 2], 3], 4]))
