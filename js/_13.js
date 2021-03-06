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

const contains = (dots, p) => dots.find((e) => e[0] === p[0] && e[1] === p[1])

function viz(dots) {
  const mx = Math.max(...dots.map((p) => p[0]))
  const my = Math.max(...dots.map((p) => p[1]))
  const cy = []
  for (let y = 0; y <= my; y++) {
    let cx = []
    for (let x = 0; x <= mx; x++) {
      if (contains(dots, [x, y])) {
        cx.push('#')
      } else {
        cx.push('.')
      }
    }
    cy.push(cx.join(''))
  }
  return cy.join('\n')
}

function fold1(dots, f) {
  let [fx, fy] = f

  let result = dots.map(([x, y]) => {
    if (fy > 0) {
      if (y < fy) {
        return [x, y]
      } else {
        return [x, fy - (y - fy)]
      }
    } else {
      if (x < fx) {
        return [x, y]
      } else {
        return [fx - (x - fx), y]
      }
    }
  })

  return result.reduce((a, p) => {
    if (!contains(a, p)) a.push(p)
    return a
  }, [])
}

const fold = (dots, folds) => folds.reduce((a, f) => fold1(a, f), dots)

const p1 = ({ dots, folds }) => fold(dots, folds.slice(0, 1)).length
const p2 = ({ dots, folds }) => viz(fold(dots, folds))

const sheet = parse(input)
console.log(p1(sheet))
console.log(p2(sheet))
