const { utils } = require('ethers')

let input = `
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
`

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString()
}

function* chunks(xs) {
  for (let i = 0; i < xs.length; i += 4) {
    yield [xs[i], xs[i+1], xs[i+2], xs[i+3]]
  }
}

function parse(input) {
  return [...chunks(numbers(input))]
}

function numbers(s) {
  return s
    .split(/[^\d.]+/)
    .filter((t) => t !== '')
    .map(Number)
}

function p1(input) {
  return score(play(parseGame(input)).next().value)
}

function p2(input) {
  let generator = play(parseGame(input))
  while (true) {
    let { value, done } = generator.next()
    if (done) return score(lastValue)
    lastValue = value
  }
}

console.log(parse(input))
// console.log(p1(input))
// console.log(p2(input))
