let input = `
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

function parse(input) {
  const lines = input.split('\n')
  const template = lines[0].split('')
  const rulesKV = lines.slice(2, lines.length).map((s) => s.split(/[ ->]+/))
  const rules = new Map(rulesKV)
  return { template, rules }
}

function sim({ template, rules }, steps) {
  return [...Array(steps)].reduce((a, _) => step(a, rules), template)
}

function step(t, rules) {
  let next = []
  let residue
  for (let i = 0; i < t.length - 1; i++) {
    const key = [t[i], t[i + 1]].join('')
    const value = rules.get(key)
    next.push(t[i])
    if (value) {
      next.push(value)
      residue = t[i + 1]
    } else {
      next.push(t[i + 1])
      residue = null
    }
  }
  if (residue) next.push(residue)
  return next
}

const count = (xs) =>
  xs.reduce((m, x) => m.set(x, (m.get(x) ?? 0) + 1), new Map())

const minMax = (xs) => [Math.min(...xs), Math.max(...xs)]

function diff(polymer) {
  const counts = count(polymer)
  console.log(counts)
  const [min, max] = minMax([...counts.values()])
  return max - min
}

const pairs = (xs) =>
  [...Array(xs.length - 1)].map((_, i) => [xs[i], xs[i + 1]].join(''))

const incr = (m, k) => m.set(k, (m.get(k) ?? 0) + 1)
const decr = (m, k) => m.set(k, m.get(k) - 1)

function sim2({ template, rules }, steps) {
  let c1 = count(template)
  let c2 = count(pairs(template))
  for (; steps > 0; steps--) {
    // console.log('step', steps)
    const keys = [...c2.entries()].filter((e) => e[1] > 0).map((e) => e[0])
    for (const p of keys) {
      const n = rules.get(p)
      incr(c1, n)
      decr(c2, p)
      incr(c2, [p[0], n].join(''))
      incr(c2, [n, p[1]].join(''))
      // console.log(n)
    }
    // console.log(c2)
  }
  console.log(c1)
  const [min, max] = minMax([...c1.values()])
  return max - min
}

const p1 = (puzzle) => diff(sim(puzzle, 3))
const p2 = (puzzle) => sim2(puzzle, 3)

const puzzle = parse(input)
console.log(p1(puzzle))
console.log(p2(puzzle))
