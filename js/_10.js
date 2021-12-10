let input = `
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split(/\s+/)

function score(s, tryFix) {
  let stack = []
  for (const c of s) {
    if (c === ')') {
      if (stack.pop() === '(') continue
      else return 3
    }
    if (c === ']') {
      if (stack.pop() === '[') continue
      else return 57
    }
    if (c === '}') {
      if (stack.pop() === '{') continue
      else return 1197
    }
    if (c === '>') {
      if (stack.pop() === '<') continue
      else return 25137
    }
    stack.push(c)
  }

  if (!tryFix) return 0

  let t = 0
  while (stack.length > 0) {
    t *= 5
    const c = stack.pop()
    if (c === '(') t += 1
    if (c === '[') t += 2
    if (c === '{') t += 3
    if (c === '<') t += 4
  }
  return t
}

const sum = (xs) => xs.reduce((a, x) => a + x)
const p1 = (lines) => sum(lines.map((s) => score(s)))
const p2 = (lines) => sum(lines.map((s) => score(s, true)))

const lines = parse(input)
console.log(p1(lines))
console.log(p2(lines))
