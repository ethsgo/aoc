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

const count = (xs) =>
  xs.reduce((m, x) => m.set(x, (m.get(x) ?? 0) + 1), new Map())

const pairs = (xs) =>
  [...Array(xs.length - 1)].map((_, i) => [xs[i], xs[i + 1]].join(''))

const incr = (m, k, d) => m.set(k, (m.get(k) ?? 0) + d)
const minMax = (xs) => [Math.min(...xs), Math.max(...xs)]

function sim({ template, rules }, steps) {
  let c1 = count(template)
  let c2 = count(pairs(template))
  for (; steps > 0; steps--) {
    const kv = [...c2.entries()].filter((e) => e[1] > 0)
    for (let [p, v] of kv) {
      const n = rules.get(p)
      incr(c1, n, v)
      incr(c2, p, -v)
      incr(c2, [p[0], n].join(''), v)
      incr(c2, [n, p[1]].join(''), v)
    }
  }
  const [min, max] = minMax([...c1.values()])
  return max - min
}

const p1 = (puzzle) => sim(puzzle, 10)
const p2 = (puzzle) => sim(puzzle, 40)

const puzzle = parse(input)
console.log(p1(puzzle))
console.log(p2(puzzle))
