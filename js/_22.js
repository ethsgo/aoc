let input = `
on x=10..12,y=10..12,z=10..12
on x=11..13,y=11..13,z=11..13
off x=9..11,y=9..11,z=9..11
on x=10..10,y=10..10,z=10..10
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) =>
  input.split('\n').map((line) => {
    let [t, nums] = line.split(' ')
    let range = nums.split(/[^-\d]+/).map(Number)
    range.shift()
    return { on: t === 'on', range }
  })

function inRange(s, x, y, z) {
  const r = s.range
  return (
    r[0] <= x && x <= r[1] && r[2] <= y && y <= r[3] && r[4] <= z && z <= r[5]
  )
}

function count(seq) {
  let c = 0
  seq = [...seq].reverse()
  for (let x = -50; x <= 50; x++) {
    for (let y = -50; y <= 50; y++) {
      for (let z = -50; z <= 50; z++) {
        for (const s of seq) {
          if (inRange(s, x, y, z)) {
            if (s.on) c++
            break
          }
        }
      }
    }
  }
  return c
}

const p1 = (seq) => count(seq)

const seq = parse(input)
console.log(p1(seq))
