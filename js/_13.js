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

function viz(dots) {
  const mx = Math.max(...dots.map((p) => p[0]))
  const my = Math.max(...dots.map((p) => p[1]))
  for (let y = 0; y < my; y++) {
    let cx = []
    for (let x = 0; x < mx; x++) {
      if (dots.find((e) => e[0] === x && e[1] === y)) {
        cx.push('#')
      } else {
        cx.push('.')
      }
    }
    console.log(cx.join(''))
  }
}

function fold(dots, foldY) {
  let result = []
  for (const [x, y] of dots) {
    if (y < foldY) {
      result.push([x, y])
    } else {
      const f = [x, y] //foldY - (y - foldY)]
      result.push(f)
    }
  }

  return result.reduce((a, p) => {
    if (!a.find((e) => e[0] === p[0] && e[1] === p[1])) a.push(p)
    return a
  }, [])
}

function p1({ dots, folds }) {
  viz(dots)
  const d1 = fold(dots, folds[0][1])
  console.log()
  viz(d1)
}

console.log(p1(parse(input)))
