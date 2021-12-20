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

/// Return a new image by padding the given image by 2 pixels on each side.
function padded(image) {
  const w = image[0].length
  const h = image.length
  const emptyRow = [...Array(w + 2 * 2)].map((_) => '.')

  let newImage = []
  for (let i = 0; i < h + 2 * 2; i++) {
    if (i < 2 || i >= h + 2) {
      newImage[i] = [...emptyRow]
    } else {
      newImage[i] = ('..' + image[i - 2].join('') + '..').split('')
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
  const base = padded(image)
  let next = copy(base)

  const w = base[0].length
  const h = base.length

  function pixels(y, x) {
    let px = []
    if (y > 0 && x > 0) px.push(base[y - 1][x - 1])
    else px.push('.')
    if (y > 0) px.push(base[y - 1][x])
    else px.push('.')
    if (y > 0 && x + 1 < w) px.push(base[y - 1][x + 1])
    else px.push('.')
    if (x > 0) px.push(base[y][x - 1])
    else px.push('.')
    px.push(base[y][x])
    if (x + 1 < w) px.push(base[y][x + 1])
    else px.push('.')
    if (y + 1 < h && x > 0) px.push(base[y + 1][x - 1])
    else px.push('.')
    if (y + 1 < h) px.push(base[y + 1][x])
    else px.push('.')
    if (y + 1 < h && x + 1 < h) px.push(base[y + 1][x + 1])
    else px.push('.')
    return px
  }

  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      // prettier-ignore
      // let pixels = [
      //   base[y - 1][x - 1], base[y - 1][x], base[y - 1][x + 1],
      //   base[y + 0][x - 1], base[y + 0][x], base[y + 0][x + 1],
      //   base[y + 1][x - 1], base[y + 1][x], base[y + 1][x + 1],
      // ]
      next[y][x] = map[decimal(pixels(y, x))]
    }
  }

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
