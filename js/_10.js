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

function match(s) {
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
  return stack
}

function corrupted(s) {
  const m = match(s)
  return typeof m === 'number' ? m : 0
}

function incomplete(s) {
  const m = match(s)
  // ignore corrupted lines
  if (typeof m === 'number') return 0
  // otherwise we get back the stack when parsing finished
  const stack = m

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
const median = (xs) => [...xs].sort((x, y) => x - y)[(xs.length - 1) / 2]

const p1 = (lines) => sum(lines.map((s) => corrupted(s)))
const p2 = (lines) =>
  median(lines.map((s) => incomplete(s, true)).filter((x) => x > 0))

const lines = parse(input)
console.log(p1(lines))
console.log(p2(lines))
