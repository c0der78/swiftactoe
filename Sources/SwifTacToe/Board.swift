class Board {

  var board: [[Tile]]

  init(size: Int = 3) {
    board = []

    for _ in 0...size - 1 {
      var line = [Tile]()
      for _ in 0...size - 1 {
        line.append(Tile.none)
      }
      board.append(line)
    }
  }

  init(copy: Board) {
    board = []

    for i in 0...copy.size - 1 {
      var line = [Tile]()
      for j in 0...copy.size - 1 {
        line.append(copy[i, j])
      }
      board.append(line)
    }
  }

  var size: Int {
    return board.count
  }

  var moves: Int {
    return board.count * board.count
  }

  func randomMove() -> Point? {
    return self.availableMoves().randomElement()
  }

  private func hasWonDiagnal(player: Tile) -> Bool {

    var found = true

    // check the first diagnal
    for i in 0...board.count - 1 {
      // if not found
      if board[i][i] != player {
        found = false
        break
      }
    }

    if found {
      return true
    }

    found = true
    var j = 0
    let i = board.count - 1
    for i in stride(from: i, to: -1, by: -1) {
      if j >= board.count || board[i][j] != player {
        found = false
        break
      }
      j += 1
    }

    return found
  }

  func hasWon(_ player: Tile) -> Bool {
    // check diagnal
    if self.hasWonDiagnal(player: player) {
      return true
    }

    // check each row
    for i in 0...board.count - 1 {

      var found = true
      for j in 0...board.count - 1 {
        if board[i][j] != player {
          found = false
          break
        }
      }
      if found {
        return true
      }
    }

    for i in 0...board.count - 1 {
      var found = true

      for j in 0...board.count - 1 {
        if board[j][i] != player {
          found = false
          break
        }
      }

      if found {
        return true
      }
    }

    return false
  }

  func availableMoves() -> [Point] {
    var availablePoints = [Point]()

    for i in 0...board.count - 1 {
      for j in 0...board[i].count - 1 {
        if board[i][j] == Tile.none {
          availablePoints.append(Point(x: i, y: j))
        }
      }
    }
    return availablePoints
  }

  func placeMove(point: Point, player: Tile) -> Bool {

    if point.x < 0 || point.x >= board.count || point.y < 0 || point.y >= board.count {
      return false
    }

    if self.board[point.x][point.y] != Tile.none {
      return false
    }

    self.board[point.x][point.y] = player
    return true
  }

  subscript(x: Int, y: Int) -> Tile {
    get {
      if x < 0 || x >= board.count || y < 0 || y >= board.count {
        return Tile.none
      }
      return self.board[x][y]
    }
    set(value) {
      if x >= 0 && x < board.count && y >= 0 && y < board.count {
        self.board[x][y] = value
      }
    }
  }
}
