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
  let memo = new Map()

  function winCount(pos, score, pi) {
    const key = JSON.stringify([pos, score, pi])
    let v = memo.get(key)
    if (v) return v

    if (score[0] >= 21) {
      v = [1, 0]
    } else if (score[1] >= 21) {
      v = [0, 1]
    } else {
      v = [0, 0]
      for (const d1 of [1, 2, 3]) {
        for (const d2 of [1, 2, 3]) {
          for (const d3 of [1, 2, 3]) {
            let d = d1 + d2 + d3
            let pc = [...pos]
            let sc = [...score]
            const ni = pi === 0 ? 1 : 0

            pc[pi] = wrap(pc[pi] + (d % 10))
            sc[pi] += pc[pi]

            const w = winCount(pc, sc, ni)
            v[0] += w[0]
            v[1] += w[1]
          }
        }
      }
    }

    memo.set(key, v)
    return v
  }

  return Math.max(...winCount([i1, i2], [0, 0], 0))
}

const p1 = (pos) => gameD(...pos)
const p2 = (pos) => gameQ(...pos)

const pos = parse(input)
console.log(p1(pos))
console.log(p2(pos))
