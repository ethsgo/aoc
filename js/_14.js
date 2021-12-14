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
  const [min, max] = minMax([...counts.values()])
  return max - min
}

const p1 = (puzzle) => diff(sim(puzzle, 10))

const puzzle = parse(input)
console.log(p1(puzzle))
