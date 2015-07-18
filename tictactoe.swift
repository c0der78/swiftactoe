
class Point {

    var x: Int;
    var y: Int;

    init(x: Int, y: Int) {
        self.x = x;
        self.y = y;
    }

    var description: String {
        return "[\(x), \(y)]";
    }
}

class Board {

    var board: [[Int]];

    init(size: Int = 3) {
        board = [];

        for(var i = 0; i < size; i++) {
            var line = [Int]();
            for(var j = 0; j < size; j++) {
                line.append(0);
            }
            board.append(line);
        }
    }

    init(copy: Board) {
        board = [];

        for(var i = 0; i < size; i++) {
            var line = [Int]();
            for(var j = 0; j < size; j++) {
                line.append(copy[i, j]);
            }
            board.append(line);
        }
    }

    var size: Int {
        return board.count;
    }

    private func hasWonDiagnal(player: Int) -> Bool {

        var found = true;

        // check the first diagnal
        for(var i = 0, j = 0; i < board.count && j < board.count; i++, j++) {
            // if not found
            if(board[i][j] != player) {
                found = false;
                break;
            }
        }

        if (found) {
            return true;
        }

        found = true;

        for(var i = board.count-1, j = 0; i >= 0 && j < board.count; i--, j++) {

            if (board[i][j] != player) {
                found = false;
                break;
            }
        }

        return found;
    }

    func hasWon(player: Int) -> Bool {
        // check diagnal
        if (self.hasWonDiagnal(player)) {
            return true;
        }

        // check each row
        for (var i = 0; i < board.count; ++i) {

            var found = true;
            for(var j = 0; j < board.count; j++) {
                if(board[i][j] != player) {
                    found = false;
                    break;
                }
            }
            if (found) {
                return true;
            }
        }

        for(var i = 0; i < board.count; ++i) {
            var found = true;

            for(var j = 0; j < board.count; ++j) {
                if(board[j][i] != player) {
                    found = false;
                    break;
                }
            }

            if (found) {
                return true;
            }
        }

        return false;
    }

    func availablePoints() -> [Point] {
        var availablePoints = [Point]();

        for (var i = 0; i < board.count; ++i) {
            for (var j = 0; j < board[i].count; ++j) {
                if (board[i][j] == 0) {
                    availablePoints.append(Point(x: i, y: j));
                }
            }
        }
        return availablePoints;
    }

    func placeMove(point: Point, player: Int) -> Bool {

        if (point.x < 0 || point.x >= board.count ||
        point.y < 0 || point.y >= board.count) {
            return false;
        }

        if (self.board[point.x][point.y] != 0) {
            return false;
        }

        self.board[point.x][point.y] = player;
        return true;
    }

    subscript(x: Int, y: Int) -> Int {
        get {
            if (x < 0 || x >= board.count ||
            y < 0 || y >= board.count) {
                return 0;
            }
            return self.board[x][y];
        }
        set(value) {
            if (x >= 0 && x < board.count &&
            y >= 0 && y < board.count) {
                self.board[x][y] = value;
            }
        }
    }
}
