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

const ps = parse(input)
console.log(p1(ps))
//console.log(p2(ps))
