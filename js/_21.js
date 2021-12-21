let input = `
Player 1 starting position: 4
Player 2 starting position: 8
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split('\n').map((s) => Number(s.split(':')[1]))

const wrap = (i) => (i > 10 ? i - 10 : i)

function gameD(i1, i2) {
  let dice = 1
  let s1 = 0
  let s2 = 0
  let rolls = 0
  function move(i) {
    const d = dice + dice + 1 + dice + 2
    dice = dice + 3
    rolls += 3
    return wrap(i + (d % 10))
  }
  while (true) {
    i1 = move(i1)
    s1 += i1
    if (s1 >= 1000) return s2 * rolls
    i2 = move(i2)
    s2 += i2
    if (s2 >= 1000) return s1 * rolls
  }
}

function gameQ(i1, i2) {
  return _gameQ(i1, i2, 0, 0)
}

function _gameQ(i1, i2, s1, s2) {
  let dice = 1
  let rolls = 0
  function move(i) {
    const d = dice + dice + 1 + dice + 2
    dice = dice + 3
    rolls += 3
    return wrap(i + (d % 10))
  }
  while (true) {
    i1 = move(i1)
    s1 += i1
    if (s1 >= 1000) return s2 * rolls
    i2 = move(i2)
    s2 += i2
    if (s2 >= 1000) return s1 * rolls
  }
}

const p1 = (data) => gameD(...data)
const p2 = (data) => gameQ(...data)

const data = parse(input)
console.log(p1(data))
console.log(p2(data))
