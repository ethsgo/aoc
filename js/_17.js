let input = '8A004A801A8002F478'

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

const parse = (input) => input.split('')

const p1 = (p) => p

const p = parse(input)
console.log(p1(p))
