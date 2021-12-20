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

const row = (fill, n) => [...Array(n)].map((_) => fill)

function pad1(image, fill) {
  const w = image[0].length
  const h = image.length

  let padded = []
  for (let i = 0; i < h + 2; i++) {
    if (i === 0 || i === h + 1) {
      padded[i] = row(fill, w + 2)
    } else {
      padded[i] = [fill, ...image[i - 1], fill]
    }
  }

  return padded
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
  const base = pad1(image, fill)
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

  return next
}

const lightCount = (xs) =>
  xs.reduce((a, row) => a + row.reduce((a, c) => a + (c === '#' ? 1 : 0), 0), 0)

function iter({ map, image }, steps) {
  fill = '.'
  for (i = 0; i < steps; i++) {
    image = enhance(map, image, fill)
    fill = map[decimal(row(fill, 9))]
  }
  return lightCount(image)
}

const p1 = (data) => iter(data, 2)
const p2 = (data) => iter(data, 50)

const data = parse(input)
console.log(p1(data))
console.log(p2(data))
