let input = `
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

function parse(input) {
  const tokens = input.split(/\s+/)
  return tokens
}

function p1(entries) {
  return 0
}

const p2 = 0

const entries = parse(input)
console.log(p1(entries))
// console.log(p2(entries))
