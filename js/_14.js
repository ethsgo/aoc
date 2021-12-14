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
  const rules = lines.slice(2, lines.length).map((s) => s.split(/[ ->]+/))
  return { template, rules }
}

function p1({ template, rules }) {
  let next = [...template]
  return next
}

console.log(p1(parse(input)))
