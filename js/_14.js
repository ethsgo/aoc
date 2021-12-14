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
  const template = lines[0]
  const rulesKV = lines.slice(2, lines.length).map((s) => s.split(/[ ->]+/))
  const rules = new Map(rulesKV)
  return { template, rules }
}

function p1({ template, rules }) {
  return step({ s: template, rules })
}

function step({ s, rules }) {
  let next = []
  let residue
  for (let i = 0; i < s.length - 1; i++) {
    const key = [s[i], s[i + 1]].join('')
    const value = rules.get(key)
    if (value) {
      next.push([s[i], value].join(''))
      residue = s[i + 1]
    } else {
      next.push(key)
      residue = null
    }
  }
  if (residue) next.push(residue)
  return next.join('')
}

console.log(p1(parse(input)))
