const { log } = require('console')

let input = `
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##
#..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###
.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#.
.#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#.....
.#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#..
...####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.....
..##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

function parse(input) {
  const lines = input.split('\n')

  let map = []
  let i = 0
  for (; i < lines.length; i++) {
    let line = lines[i]
    if (line.length === 0) {
      i++
      break
    }
    map.push(line)
  }
  map = map.join('').split('')

  let image = []
  for (; i < lines.length; i++) {
    image.push([...lines[i]])
  }

  return { map, image }
}

function show(image) {
  console.log(image.map((row) => row.join('')).join('\n'))
}

/// Return a new image by padding the given image by 1 pixel on each side.
function padded1(image) {
  const w = image[0].length
  const h = image.length
  const emptyRow = [...Array(w + 2)].map((_) => '.')

  let newImage = []
  for (let i = 0; i < h + 2; i++) {
    if (i === 0 || i === h + 1) {
      newImage[i] = [...emptyRow]
    } else {
      newImage[i] = ('.' + image[i - 1].join('') + '.').split('')
    }
  }

  return newImage
}

/// Return a new image by padding the given image by n pixel on each side.
function padded(image, n = 1) {
  const w = image[0].length
  const h = image.length
  const emptyRow = [...Array(w + 2 * n)].map((_) => '.')
  const side = [...Array(n)].map((_) => '.')

  let newImage = []
  for (let i = 0; i < h + 2 * n; i++) {
    if (i < n || i >= h + n) {
      newImage[i] = [...emptyRow]
    } else {
      newImage[i] = [...side, ...image[i - n], ...side]
    }
  }

  return newImage
}

const copy = (image) => image.map((row) => [...row])

function decimal(pixels) {
  let d = 0
  for (const p of pixels) {
    d *= 2
    if (p === '#') d++
  }
  return d
}

function enhance(map, image) {
  // const base = copy(image)//padded(image, 5)
  const base = padded(image, 3)
  console.log('base')
  show(base)
  let next = copy(base)

  const w = base[0].length
  const h = base.length

  console.log({ baseW: w, baseH: h, imgW: image[0].length, imgH: image.length })

  function pixels(y, x, debug) {
    let px = []
    for (const dy of [-1, 0, 1]) {
      const u = y + dy
      if (u >= 0 && u < h) {
        for (const dx of [-1, 0, 1]) {
          const v = x + dx
          if (v >= 0 && v < w) {
            if (debug) console.log(u, v, base[u][v])
            px.push(base[u][v])
          } else {
            if (debug) console.log(u, v, '.')
            px.push('.')
          }
        }
      } else {
        if (debug) console.log(u, '-', '...')
        px = [...px, ...'...']
      }
    }

    return px
  }

  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
  // for (let y = 4; y < h - 4; y++) {
  //   for (let x = 4; x < w - 4; x++) {
      // prettier-ignore
      // let pixels = [
      //   base[y - 1][x - 1], base[y - 1][x], base[y - 1][x + 1],
      //   base[y + 0][x - 1], base[y + 0][x], base[y + 0][x + 1],
      //   base[y + 1][x - 1], base[y + 1][x], base[y + 1][x + 1],
      // ]
      // if (y +1 === h && x +1 === w) {
      //   const px = pixels(y, x, true)
      //   const d = decimal(px)
      //   const m = map[d]
      //   console.log({y, x, d, m})
      //   console.log(px.join(''))
      // }
      next[y][x] = map[decimal(pixels(y, x))]
    }
  }

  console.log('next')
  show(next)
  console.log('--')
  return next
}

const lightCount = (xs) =>
  xs.reduce((a, row) => a + row.reduce((a, c) => a + (c === '#' ? 1 : 0), 0), 0)

function p1({ map, image }) {
  show(image)
  image = enhance(map, image)
  image = enhance(map, image)
  show(image)
  return lightCount(image)
}

const data = parse(input)
console.log(p1(data))
