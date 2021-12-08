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

// Shorter input variation, useful for p2
let inputShort = `
acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf
`.trim()
input = inputShort

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

function p2e(entry) {
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
  console.log(sofd, c5, c6)
  // Find the segments common in all patterns of length 5
  const co5 = intersection(intersection(c5[0], c5[1]), c5[2])
  // Cross these off in the segments in the pattern for 7. This eliminates
  // vertical segments, and what is left is the right horizontal segments.
  const hr5 = difference(sofd[7], co5)
  // The pattern of length 5 has both the horizontal ones is the digit 3.
  sofd[3] = union(co5, hr5)
  // Of the remaining patterns of length 5, the one that shares a horizontal
  // segment with 3 is the digit 2.
  for (let s5 of c5) {
    const h = difference(s5, co5)
    console.log(difference(h, hr5))
  }
  //
  //   console.log([...union(s5, hr5)].length)
  //   if (union(s5, hr5) == s5)
  // }
  // The other
  console.log(sofd[3])
  return 0
}
function p2(ps) {
  return p2e(ps[0])
}

const ps = parse(input)
// console.log(p1(ps))
console.log(p2(ps))
