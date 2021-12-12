let input = `

`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split(/\s+/).map((s) => [...s].map(Number))

const p1 = (oct) => 0

console.log(p1(parse(input)))
