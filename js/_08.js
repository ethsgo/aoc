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

function p1(ps) {
  return ps.reduce((a, { patterns, digits }) => {
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
  // Segments of digits
  let sofd = {}
  // Candidates patterns of length 5 and 6
  let c5 = []
  let c6 = []

  for (let p of entry.patterns) {
    const len = p.length
    const s = new Set(p)
    if (len === 2) sofd[1] = s
    if (len === 3) sofd[7] = s
    if (len === 4) sofd[4] = s
    if (len === 7) sofd[8] = s
    if (len === 5) c5.push(s)
    if (len === 6) c6.push(s)
  }

  // Find the segments common in all patterns of length 5. These are the
  // three horizontal segments.
  const h = intersection(intersection(c5[0], c5[1]), c5[2])
  // Digit 3 has all of these, and the two additional right vertical segments,
  // which'll be those that are on in the digit 1.
  sofd[3] = union(h, sofd[1])

  // Removing the segments of digit 3 from digit 4, we get the top left
  // vertical segment.
  const vtl = [...difference(sofd[4], sofd[3])][0]

  // Of the remaining patterns of length 5, the one that has the vertical top
  // left segment on is the digit 5. The other one is digit 2.
  for (let s5 of c5) {
    if (equal(s5, sofd[3])) continue
    sofd[s5.has(vtl) ? 5 : 2] = s5
  }

  // Digits 9 has one extra segment in addition to digit 3.
  for (let s6 of c6) {
    if (difference(s6, sofd[3]).size === 1) {
      sofd[9] = s6
    } else {
      // Digit 9 has all three of the horizontal segments
      sofd[equal(intersection(s6, h), h) ? 6 : 0] = s6
    }
  }

  return sofd
}

function value(entry) {
  let result = 0
  const segments = deduceSegments(entry)
  for (const d of entry.digits.map((d) => new Set(d))) {
    for (const k in segments) {
      const v = segments[k]
      if (equal(d, v)) {
        result *= 10
        result += Number(k)
        break
      }
    }
  }
  return result
}

const sum = (xs) => xs.reduce((a, x) => a + x, 0)
const p2 = (ps) => sum(ps.map((p) => value(p)))

const ps = parse(input)
console.log(p1(ps))
console.log(p2(ps))
