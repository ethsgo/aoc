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

// The first line is the draw
const [drawInput, ...remainingLines] = input.split('\n')
const remainingInput = remainingLines.join('\n')

function toNumbers(s) {
  return s
    .split(/[^\d.]+/)
    .filter((t) => t.length > 0)
    .map(Number)
}

function parseBoards(numbers) {
  let boards = []
  let board = [[]]
  let [x, y] = [0, 0]
  for (let i = 0; i < numbers.length; i++) {
    board[y].push(numbers[i])
    if (x === 4 && y === 4) {
      // Start a new board
      boards.push(board)
      board = [[]]
      x = 0
      y = 0
    } else if (x === 4) {
      // Start a new row
      board.push([])
      x = 0
      y++
    } else {
      x++
    }
  }
  return boards
}

const draw = toNumbers(drawInput)
const boards = parseBoards(toNumbers(remainingInput))

function play(draw, boards) {
  for (let i = 0; i < draw.length; i++) {
    // Draw a call, and mark it on all boards.
    const call = draw[i]
    for (let b = 0; b < boards.length; b++) {
      for (let y = 0; y < 5; y++) {
        for (let x = 0; x < 5; x++) {
          if (boards[b][y][x] === call) {
            boards[b][y][x] = -call
          }
        }
      }
    }

    // Check to see if someone won.
    for (let b = 0; b < boards.length; b++) {
      const board = boards[b]
      for (let y = 0; y < 5; y++) {
        if (board[y].every((n) => n < 0)) {
          return { b, call, y, board }
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
          return { b, call, x, board }
        }
      }
    }
  }
}

function p1(draw, boards) {
  const { call, board } = play(draw, boards)
  const unmarkedSum = board
    .flat()
    .filter((n) => n > 0)
    .reduce((n, s) => n + s)
  // return { call, unmarkedSum, board }
  return call * unmarkedSum
}

console.log(p1(draw, boards))
// console.log(p2(tokens))
