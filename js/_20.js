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
  let w = image[0].length
  let h = image.length
  let emptyRow = [...Array(w + 2 * 4)].map((_) => '.')

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

function p1({ map, image }) {
  show(image)
  let newImage = padded(image)
  show(newImage)
}

const data = parse(input)
console.log(p1(data))
