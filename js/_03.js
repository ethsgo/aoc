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
  const px = parityBits(tokens)
  const bits = px.join('')
  const inverse = px.map((x) => (x === '1' ? '0' : '1')).join('')
  return parseInt(bits, 2) * parseInt(inverse, 2)
}

function parityBits(numbers) {
  return [...Array(numbers[0].length)].map((_, i) => {
    const ones = numbers.filter((n) => n[i] == '1')
    return ones.length > numbers.length / 2 ? '1' : '0'
  })
}

function p2(numbers) {
  return reduce(numbers, 0, true) * reduce(numbers, 0, false)
}

function reduce(numbers, i, mostCommon) {
  if (numbers.length == 1) return parseInt(numbers[0], 2)
  const ones = numbers.filter((n) => n[i] === '1')
  const zeroes = numbers.filter((n) => n[i] == '0')
  const useOnes = ones.length >= zeroes.length == mostCommon
  return reduce(useOnes ? ones : zeroes, i + 1, mostCommon)
}

console.log(p1(tokens))
console.log(p2(tokens))
