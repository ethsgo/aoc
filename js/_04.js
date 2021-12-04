const { utils } = require('ethers')

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

function toNumbers(s) {
  return s
    .split(/[^\d.]+/)
    .filter((t) => t.length > 0)
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

function parseGame(input) {
  // The first line is the draw
  const [drawInput, ...remainingLines] = input.split('\n')
  const remainingInput = remainingLines.join('\n')

  const draw = toNumbers(drawInput)
  const boards = parseBoards(toNumbers(remainingInput))
  return { draw, boards }
}

function play({ draw, boards }, { toEnd = false } = {}) {
  let hasWon = {}
  let lastWin
  for (let i = 0; i < draw.length; i++) {
    // Draw a call
    const call = draw[i]
    for (let b = 0; b < boards.length; b++) {
      // Skip boards that have already won.
      if (hasWon[b]) continue

      const board = boards[b]

      // Mark the call on the board
      for (let y = 0; y < 5; y++) {
        for (let x = 0; x < 5; x++) {
          if (board[y][x] === call) {
            board[y][x] = -1
          }
        }
      }

      // And see if the board is now complete
      if (isComplete(board)) {
        hasWon[b] = true
        lastWin = { b, call, board }
        if (!toEnd) return lastWin
      }
    }
  }
  return lastWin
}

function isComplete(board) {
  for (let y = 0; y < 5; y++) {
    if (board[y].every((n) => n < 0)) {
      return true
    }
  }

  for (let x = 0; x < 5; x++) {
    let marked = true
    for (let y = 0; y < 5; y++) {
      if (board[y][x] >= 0) {
        marked = false
        break
      }
    }
    if (marked) {
      return true
    }
  }
}
function score({ call, board }) {
  const unmarkedSum = board
    .flat()
    .filter((n) => n > 0)
    .reduce((s, n) => s + n, 0)
  return call * unmarkedSum
}

function p1(input) {
  return score(play(parseGame(input)))
}
function p2(input) {
  return score(play(parseGame(input), { toEnd: true }))
}

console.log(p1(input))
console.log(p2(input))
