let input = `
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb |
fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec |
fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef |
cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega |
efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga |
gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf |
gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf |
cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd |
ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg |
gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc |
fgae cfgab fg bagce
`.trim()

// Shorter input variation, useful for testing p2.
let inputShort = `
acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf
`.trim()
// input = inputShort

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

function parse(input) {
  const tokens = input.split(/\s+/)
  return [...Array(tokens.length / 15)].map((_, i) => {
    const s = i * 15
    return {
      patterns: tokens.slice(s, s + 10),
      digits: tokens.slice(s + 11, s + 15),
    }
  })
}

function p1(entries) {
  return entries.reduce((a, { patterns, digits }) => {
    let c = 0
    for (const d of digits) {
      if (d.length === 2) c++ // 1
      if (d.length === 3) c++ // 7
      if (d.length === 4) c++ // 4
      if (d.length === 7) c++ // 8
    }
    return a + c
  }, 0)
}

const union = (a, b) => {
  let u = new Set(a)
  for (e of b) u.add(e)
  return u
}
const intersection = (a, b) => new Set([...a].filter((e) => b.has(e)))
const difference = (a, b) => new Set([...a].filter((e) => !b.has(e)))
const equal = (a, b) => [...a].sort().toString() === [...b].sort().toString()

function deduceSegments(entry) {
  // Segments, indexed by the digit
  let sx = []

  // Candidates patterns of length 5 and 6
  let c5 = []
  let c6 = []

  for (const p of entry.patterns) {
    const len = p.length
    const s = new Set(p)
    if (len === 2) sx[1] = s
    if (len === 3) sx[7] = s
    if (len === 4) sx[4] = s
    if (len === 7) sx[8] = s
    if (len === 5) c5.push(s)
    if (len === 6) c6.push(s)
  }

  // Find the segments common in all patterns of length 5. These are the
  // three horizontal segments.
  const h = intersection(intersection(c5[0], c5[1]), c5[2])
  // Digit 3 has all of these, and additionally has the the same two right
  // vertical segments as digit 1.
  sx[3] = union(h, sx[1])

  // Removing the segments of digit 3 from digit 4, we get the top left
  // vertical segment.
  const vtl = [...difference(sx[4], sx[3])][0]

  // Of the remaining patterns of length 5, the one that has the vertical top
  // left segment on is the digit 5. The other one is digit 2.
  for (const s5 of c5) {
    if (equal(s5, sx[3])) continue
    sx[s5.has(vtl) ? 5 : 2] = s5
  }

  // Digits 9 has one extra segment in addition to digit 3.
  for (const s6 of c6) {
    if (difference(s6, sx[3]).size === 1) {
      sx[9] = s6
    } else {
      // Digit 9 has all three of the horizontal segments
      sx[equal(intersection(s6, h), h) ? 6 : 0] = s6
    }
  }

  return sx
}

function value(entry) {
  const segments = deduceSegments(entry)
  const digits = entry.digits.map((d) => new Set(d))
  return digits.reduce((a, d) => {
    return a * 10 + segments.findIndex((s) => equal(d, s))
  }, 0)
}

const sum = (xs) => xs.reduce((a, x) => a + x, 0)
const p2 = (entries) => sum(entries.map((e) => value(e)))

const entries = parse(input)
console.log(p1(entries))
console.log(p2(entries))
