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

function p1({ template, rules }) {
  return step(template, rules)
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

console.log(p1(parse(input)))
