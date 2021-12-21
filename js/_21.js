let input = `
Player 1 starting position: 4
Player 2 starting position: 8
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split('\n').map((s) => Number(s.split(':')[1]))

const wrap = (i) => (i > 10 ? i - 10 : i)

function game(i1, i2) {
  let dice = 1
  let s1 = 0
  let s2 = 0
  let rolls = 0
  function move(i) {
    const d = dice + dice + 1 + dice + 2
    dice = dice + 3
    const j = wrap(i + (d % 10))
    console.log({ i, j, d, dice })
    return j
  }
  while (true) {
    i1 = move(i1)
    s1 += i1
    rolls += 3
    console.log('player 1 score', s1, i1)
    if (s1 >= 1000) break
    i2 = move(i2)
    s2 += i2
    console.log('player 2 score', s2, i2)
    rolls += 3
    if (s2 >= 1000) break
  }
  return (s1 >= 1000 ? s2 : s1) * rolls
}

const p1 = (data) => game(...data)

const data = parse(input)
console.log(p1(data))
