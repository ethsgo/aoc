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

// Convert string bit array to a boolean bit array
const boolBits = (bits) => [...bits].map((c) => c === '1')

function p1(tokens) {
  const px = parity(tokens)
  const bits = px.map((x) => x > 0)
  const inverse = px.map((x) => x < 0)
  return decimal(bits) * decimal(inverse)
}

function p2(numbers) {
  // If equal (parity == 0) then use 1
  const mostCommon = filter(numbers, (parity) => parity >= 0)
  // If equal (parity == 1) then use 0
  const leastCommon = filter(numbers, (parity) => parity <= 0)
  return decimal(boolBits(mostCommon))
}

/// Filter down the given numbers (provided as bit strings of their
/// binary representation) until we find a singleton that satisfies the given
/// bit criteria.
///
/// The criteria is passed the parity (positive value if there are more numbers
/// with 1 in that bit position).
function filter(numbers, criteria) {
  const len = numbers[0].length

  // For each bit position
  for (let j = 0; j < len; j += 1) {
    // Determine the most common bit in that position
    let parity = 0
    for (let i = 0; i < numbers.length; i++) {
      parity += numbers[i][j] === '0' ? +1 : -1
    }

    const bit = criteria(parity) ? '1' : '0'

    // Keep only numbers that have that bit in that position
    numbers = numbers.filter((number) => number[j] == bit)
    if (numbers.length == 1) return numbers[0]
  }

  return ''
}

console.log(p1(tokens))
console.log(p2(tokens))
