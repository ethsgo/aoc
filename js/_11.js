let input = `

`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split(/\s+/)

const p1 = (lines) => lines

const lines = parse(input)
console.log(p1(lines))
