let input = `

`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

function parse(input) {
  
}

const p1 = (pz) => pz

const pz = parse(input)
console.log(p1(pz))
