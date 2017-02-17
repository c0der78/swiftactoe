
class Point {

    var x: Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    var description: String {
        return "[\(x), \(y)]"
    }

    class func parse(str: String) -> Point? {
        // split on space and '-'
          var coords = str.characters.split { $0 == Character(" ") || $0 == Character("-") }.map { String($0) }

          if coords.count < 2 {
              return nil
          }

          let x = Int(coords[0])
          let y = Int(coords[1])

          if x == nil || y == nil {
              return nil
          }

          if x! < 1 || x! > 3 || y! < 1 || y! > 3 {
              return nil
          }

          return Point(x: x! - 1, y: y! - 1)
    }
}

class Board {

    var board: [[Int]]

    init(size: Int = 3) {
        board = []

        for _ in 0...size-1 {
            var line = [Int]()
            for _ in 0...size-1 {
                line.append(0)
            }
            board.append(line)
        }
    }

    init(copy: Board) {
        board = []

        for i in 0...copy.size-1 {
            var line = [Int]()
            for j in 0...copy.size-1 {
                line.append(copy[i, j])
            }
            board.append(line)
        }
    }

    var size: Int {
        return board.count
    }

    private func hasWonDiagnal(player: Int) -> Bool {

        var found = true

        // check the first diagnal
        for i in 0...board.count-1 {
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
	let i = board.count-1
	for i in stride(from: i, to: -1, by: -1) {
                if j >= board.count || board[i][j] != player {
                    found = false
                    break
                }
	    j += 1
        }

        return found
    }

    func hasWon(player: Int) -> Bool {
        // check diagnal
        if self.hasWonDiagnal(player: player) {
            return true;
        }

        // check each row
        for i in 0...board.count-1 {

            var found = true
            for j in 0...board.count-1 {
                if board[i][j] != player {
                    found = false
                    break
                }
            }
            if (found) {
                return true
            }
        }

        for i in 0...board.count-1 {
            var found = true

            for j in 0...board.count-1 {
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

    func availablePoints() -> [Point] {
        var availablePoints = [Point]()

        for i in 0...board.count-1 {
            for j in 0...board[i].count-1 {
                if board[i][j] == 0 {
                    availablePoints.append(Point(x: i, y: j))
                }
            }
        }
        return availablePoints
    }

    func placeMove(point: Point, player: Int) -> Bool {

        if point.x < 0 || point.x >= board.count ||
            point.y < 0 || point.y >= board.count {
            return false
        }

        if self.board[point.x][point.y] != 0 {
            return false
        }

        self.board[point.x][point.y] = player
        return true
    }

    subscript(x: Int, y: Int) -> Int {
        get {
            if x < 0 || x >= board.count ||
                y < 0 || y >= board.count {
                return 0
            }
            return self.board[x][y]
        }
        set(value) {
            if x >= 0 && x < board.count &&
                y >= 0 && y < board.count {
                self.board[x][y] = value;
            }
        }
    }
}
