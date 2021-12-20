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

/// Return a new image by padding the given image by 4 pixels on each side.
function padded(image) {
  const w = image[0].length
  const h = image.length
  const emptyRow = [...Array(w + 2 * 4)].map((_) => '.')

  let newImage = []
  for (let i = 0; i < h + 2 * 4; i++) {
    if (i < 4 || i >= h + 4) {
      newImage[i] = [...emptyRow]
    } else {
      newImage[i] = ('....' + image[i - 4].join('') + '....').split('')
    }
  }

  return newImage
}

const copy = (image) => image.map((row) => [...row])

function decimal(pixels) {
  let d = 0
  console.log(pixels)
  for (const p of pixels) {
    console.log(p, d)
    d *= 2
    if (p === '#') d++
  }
  return d
}

function p1({ map, image }) {
  show(image)

  const base = padded(image)
  let next = copy(base)

  const w = base[0].length
  const h = base.length

  // console.log(decimal('...#...#.'.split('')), 34)

  for (let y = 4; y < h - 4; y++) {
    for (let x = 4; x < w - 4; x++) {
      // prettier-ignore
      let pixels = [
        base[y - 1][x - 1], base[y - 1][x], base[y - 1][x + 1],
        base[y + 0][x - 1], base[y + 0][x], base[y + 0][x + 1],
        base[y + 1][x - 1], base[y + 1][x], base[y + 1][x + 1],
      ]
      next[y][x] = map[decimal(pixels)]
    }
  }

  show(next)
  show(base)
}

const data = parse(input)
console.log(p1(data))
