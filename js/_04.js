let input = `7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
`

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString()
}

function parseGame(input) {
  input = input.split('\n')
  // The first line is the draw
  const draw = toNumbers(input.shift())
  const boards = parseBoards(toNumbers(input.join(' ')))
  return { draw, boards }
}

function toNumbers(s) {
  return s
    .split(/[^\d.]+/)
    .filter((t) => t !== '')
    .map(Number)
}

function parseBoards(numbers) {
  let boards = []
  let board = [[]]
  let y = 0
  for (let i = 0; i < numbers.length; i++) {
    board[y].push(numbers[i])
    // If the row filled up
    if (board[y].length == 5) {
      // And we have 5 rows
      if (board.length == 5) {
        // Start a new board
        boards.push(board)
        board = [[]]
        y = 0
      } else {
        // Start a new row
        board.push([])
        y++
      }
    }
  }
  return boards
}

function* play({ draw, boards }) {
  for (let i = 0; i < draw.length; i++) {
    const call = draw[i]
    let b = 0
    while (b < boards.length) {
      for (let y = 0; y < 5; y++) {
        for (let x = 0; x < 5; x++) {
          if (boards[b][y][x] === call) {
            boards[b][y][x] = -1
          }
        }
      }

      if (isComplete(boards[b])) {
        yield { b, call, board: boards.splice(b, 1)[0] }
      } else {
        b++
      }
    }
  }
}

function isComplete(board) {
  const marked = (xs) => xs.every((n) => n < 0)
  return [...Array(5)].some(
    (_, i) =>
      marked(board[i]) || marked([...Array(5)].map((_, j) => board[j][i]))
  )
}

function score({ call, board }) {
  const unmarkedSum = board
    .flat()
    .filter((n) => n > 0)
    .reduce((s, n) => s + n, 0)
  return call * unmarkedSum
}

function p1(input) {
  return score(play(parseGame(input)).next().value)
}

function p2(input) {
  let generator = play(parseGame(input))
  while (true) {
    let { value, done } = generator.next()
    if (done) return score(lastValue)
    lastValue = value
  }
}

console.log(p1(input))
console.log(p2(input))
