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
  console.log()
}

/// Return a new image by padding the given image by n pixel on each side.
function padded(image, n, fill) {
  const w = image[0].length
  const h = image.length
  const emptyRow = [...Array(w + 2 * n)].map((_) => fill)
  const side = [...Array(n)].map((_) => fill)

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

function enhance(map, image, fill) {
  const base = padded(image, 1, fill)
  // console.log('base')
  // show(base)
  let next = copy(base)

  const w = base[0].length
  const h = base.length

  function pixels(y, x) {
    let px = []
    for (const dy of [-1, 0, 1]) {
      const u = y + dy
      if (u >= 0 && u < h) {
        for (const dx of [-1, 0, 1]) {
          const v = x + dx
          if (v >= 0 && v < w) {
            px.push(base[u][v])
          } else {
            px.push(fill)
          }
        }
      } else {
        px = [...px, fill, fill, fill]
      }
    }

    return px
  }

  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      next[y][x] = map[decimal(pixels(y, x))]
    }
  }

  // console.log('next')
  // show(next)

  return next
}

const lightCount = (xs) =>
  xs.reduce((a, row) => a + row.reduce((a, c) => a + (c === '#' ? 1 : 0), 0), 0)

function p1({ map, image }) {
  show(image)
  fill = map[0]
  image = enhance(map, image, '.')
  image = enhance(map, image, fill)
  show(image)
  return lightCount(image)
}

function p2({ map, image }) {
  show(image)
  fill = map[0]
  image = enhance(map, image, '.')
  for (i = 0; i < 49; i++) image = enhance(map, image, fill)
  show(image)
  return lightCount(image)
}

const data = parse(input)
console.log(p1(data))
console.log()
console.log(p2(data))
