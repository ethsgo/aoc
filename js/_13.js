let input = `
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

function parse(input) {
  let dots = []
  let folds = []
  let parsingDots = true
  for (const line of input.split('\n')) {
    if (line === '') {
      parsingDots = false
      continue
    }
    if (parsingDots) {
      dots.push(line.split(',').map(Number))
    } else {
      const c = Number(line.split('=')[1])
      folds.push(line.includes('y') ? [0, c] : [c, 0])
    }
  }
  return { dots, folds }
}

function p1(sheet) {
  return sheet
}

console.log(p1(parse(input)))
