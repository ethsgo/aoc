let input = `

`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split('\n')

const p1 = (xss) => xss

const xss = parse(input)
console.log(p1(xss))
