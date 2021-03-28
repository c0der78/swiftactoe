#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

class Bot : Player, InputSource {

  weak var board: Board?

  init(_ board: Board, tile: Int) {
    super.init()
    super.tile = tile
    super.input = self
    self.board = board 
  }

  func readMove() -> Point? {
    // get a list of available moves
    guard let movesAvailable = self.board?.availableMoves() else { return nil }

    // no more moves?
    if movesAvailable.count == 0 {
        return nil
    }

    sleep(1)

    if self.board?.moves == movesAvailable.count {
      return movesAvailable.randomElement()
    }

    var nextMove: Point?
    var bestMove = Int.min
    let board = Board(copy: self.board!)

    // find the best move
    for point in movesAvailable {

        if(!board.placeMove(point: point, player: super.tile)) {
            continue
        }

        let val = minmax(board: board, depth: 0, turn: super.tile)

        if val > bestMove {
            bestMove = val
            nextMove = point
        } 
    }

    return nextMove
  }
    // the minmax algorithm to recursively determine the best move
    private func minmax( board: Board, depth: Int, turn: Int) -> Int {
        let nextTurn: Int = turn == Player.X ? Player.O : Player.X

        if board.hasWon(turn) {
            return depth + 10
        }

        if board.hasWon(nextTurn) {
            return depth - 10
        }

        let movesAvailable = board.availableMoves()

        if movesAvailable.count == 0 {
            return 0
        }

        let isMaximizing = turn == self.tile

        var bestMove: Int = isMaximizing ? Int.min : Int.max 
        let decider: (Int,Int) -> Int = isMaximizing ? max : min
 
        for move in movesAvailable {  

            if (!board.placeMove(point: move, player: turn )) {
                continue
            }

            let val = minmax(board: board, depth: depth + 1, turn: nextTurn)
            bestMove = decider(bestMove, val)
        } 

        return bestMove
    }
}

