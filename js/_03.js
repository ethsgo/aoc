let input = `
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
`

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString()
}

const tokens = input.split(/\s+/).filter((t) => t.length > 0)

function p1(tokens) {
  const px = parity(tokens)
  const bits = px.map((x) => x > 0)
  const inverse = px.map((x) => x < 0)
  return decimal(bits) * decimal(inverse)
}

// Positive if there are more 1s than 0s in the given index.
function parity(tokens) {
  const len = tokens[0].length
  let parity = Array(len).fill(0)
  for (let i = 0; i < tokens.length; i++) {
    const token = tokens[i]
    for (let j = 0; j < len; j += 1) {
      parity[j] += token[j] === '1' ? +1 : -1
    }
  }
  return parity
}

// Convert boolean bit array to a decimal number
const decimal = (bits) => bits.reduce((n, x) => n * 2 + (x ? 1 : 0))

function p2(numbers) {
  return reduce(numbers, 0, true) * reduce(numbers, 0, false)
}

function reduce(numbers, i, mostCommon) {
  if (numbers.length == 1) return parseInt(numbers[0], 2)
  const zeroes = numbers.filter((n) => n[i] == '0')
  const ones = numbers.filter((n) => n[i] === '1')
  if (mostCommon) {
    if (ones.length >= zeroes.length) return reduce(ones, i + 1, mostCommon)
    else return reduce(zeroes, i + 1, mostCommon)
  } else {
    if (ones.length < zeroes.length) return reduce(ones, i + 1, mostCommon)
    else return reduce(zeroes, i + 1, mostCommon)
  }
}

console.log(p1(tokens))
console.log(p2(tokens))
