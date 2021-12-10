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

const p1 = (lines) => lines.map((s) => p1line(s)).reduce((a, x) => a + x)

function p1line(s) {
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
  return 0
}

const lines = parse(input)
console.log(p1(lines))
