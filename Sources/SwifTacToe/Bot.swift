class Bot: Player, InputSource, OutputSource {

  weak var board: Board?
  weak var io: IO?

  init(_ board: Board, _ io: IO?) {
    self.board = board
    self.io = io
    super.init()
    super.input = self
    super.output = self
  }

  func promptMove() {
    logger.trace { "prompting bot move" }
    io?.buffer("Thinking...")
  }

  func readMove() -> Point? {
    logger.trace { "reading bot move" }
    // get a list of available moves
    guard let movesAvailable = self.board?.availableMoves() else { return nil }

    // no more moves?
    if movesAvailable.count == 0 {
      return nil
    }

    wait(seconds: 1)

    if self.board?.moves == movesAvailable.count {
      return movesAvailable.randomElement()
    }

    var nextMove: Point?
    var bestMove = Int.min
    let board = Board(copy: self.board!)

    // find the best move
    for point in movesAvailable {

      if !board.placeMove(point: point, player: super.tile) {
        continue
      }

      let val = minmax(board: board, depth: board.moves, turn: super.tile)

      if val > bestMove {
        bestMove = val
        nextMove = point
      }
    }

    return nextMove
  }

  private func evaluate(_ board: Board, _ depth: Int, _ turn: Tile) -> Int {
    if board.hasWon(turn) {
      return depth + 10
    }

    if board.hasWon(turn.opposite) {
      return depth - 10
    }

    return 0
  }

  // the minmax algorithm to recursively determine the best move
  private func minmax(board: Board, depth: Int, turn: Tile) -> Int {
    let score = self.evaluate(board, depth, turn)

    if score != 0 {
      return score
    }

    let movesAvailable = board.availableMoves()

    if movesAvailable.count == 0 {
      return 0
    }

    let isMaximizing = turn == self.tile
    var bestMove = isMaximizing ? Int.min : Int.max
    let decider: (Int, Int) -> Int = isMaximizing ? max : min

    for move in movesAvailable {

      if !board.placeMove(point: move, player: turn) {
        continue
      }

      let val = minmax(board: board, depth: depth - 1, turn: turn.opposite)
      bestMove = decider(bestMove, val)
    }

    return bestMove
  }
}
