#if os(Linux)
import Glibc
#else
import Darwin
#endif

class Game
{
    // the player X/O defines
    static let PlayerX = 1
    static let PlayerO = 2
 
    private var board: Board

    var currentPlayer: Int
    var console: InputSource

    // need a board to start a isGameOver
    init(board: Board) {
      self.board = board
      self.currentPlayer = 0
      self.console = Console()
    }

    var isGameOver: Bool {
        //Game is over is someone has won, or board is full (draw)
        return (board.hasWon(player: Game.PlayerX) || board.hasWon(player: Game.PlayerO) || board.availablePoints().count == 0)
    }

    //! reads input and determines human player (X or O)
    func setHumanPlayerFromInput() -> Bool {
        let choice = console.readPlayer()

        if choice == nil {
          return false
        }

        self.currentPlayer = choice!

        // do the computers first move
        if self.currentPlayer == Game.PlayerO {
#if os(Linux)
            let p = Point(x: Int(random() % 3), y: Int(random() % 3))
#else
            let p = Point(x: Int(arc4random_uniform(3)), y: Int(arc4random_uniform(3)))
#endif
            if(!b.placeMove(point: p, player: self.opposingPlayer)) {
                  return false
            }
        }

        return true
    }

    // reads a point from input and makes a move if available
    func placeHumanMoveFromInput() -> Bool {
        print("Your move: ", terminator:"")

        let userMove = console.readPoint()

        // will use VT100 to replace the last line for error messages

        if userMove == nil {
            print("\u{1B}[A\r\u{1B}[2KInvalid point.  Try 'x-y' or 'x y'.  ", terminator: "")
            return false
        }

        if !b.placeMove(point: userMove!, player: self.currentPlayer) { //2 for O and O is the user
            print("\u{1B}[A\r\u{1B}[2KThat move is already taken.  ", terminator: "")
            return false
        }

        return true
    }

    //! calculate a computer move and place
    func placeComputerMove() -> Bool {

        if isGameOver {
          return false
        }

        let board = Board(copy: self.board)

        // get a list of available moves
        let pointsAvailable = board.availablePoints()

        // no more moves?
        if pointsAvailable.count == 0 {
            return false
        }

        var move: Point?
        var imin: Int = 2
        var alpha = 2
        var beta = -2

        // find the best move
        for point in pointsAvailable {

            if(!board.placeMove(point: point, player: self.opposingPlayer)) {
                continue
            }

            let val = alphabeta(board: board, depth: 0, alpha: &alpha, beta: &beta, turn: self.opposingPlayer)

            if imin > val {
                imin = val
                move = point
            } 

            if val == -1 {
                break
            }
        }

        if move != nil {
            return self.board.placeMove(point: move!, player: self.opposingPlayer)
        }

        return false
    }


    //! display the board to output
    func displayBoard() {

        // dislay the y coords
        print("\u{1B}[0m  y 1   2   3")

        // draw the top of the board
        printLine(length: 13, leftCorner: "x \u{1B}[1;37m┌", rightCorner: "┐", interval: "┬")

        for i in 0...board.size-1 {
            // draw each line
            print("\u{1B}[0m\(i+1) ", terminator:"")

            for j in 0...board.size-1 {

                print("\u{1B}[1;37m\u{2502}\u{1B}[1;33m", terminator:"")

                switch(board[i, j]) {
                    case Game.PlayerO:
                        print(" ◯ ", terminator:"")
                        break;
                    case Game.PlayerX:
                        print(" ╳ ", terminator:"")
                        break;
                    default:
                        print("   ", terminator:"")
                        break;
                }
            }
            print("\u{1B}[1;37m│")

            if (i + 1) != board.size {
                printLine(length: 13, leftCorner: "  \u{1B}[1;37m├", rightCorner: "┤", interval: "┼")
            }
        }

        // draw the bottom border
        printLine(length: 13, leftCorner: "  \u{1B}[1;37m└", rightCorner: "┘\u{1B}[0m", interval: "┴")
    } 

    //! display the game status
    func displayWinner() {
        if board.hasWon(player: self.currentPlayer) {
            print("You win!") //Can't happen
        } else if board.hasWon(player: self.opposingPlayer) {
            print("Unfortunately, you lost!")
        } else {
            print("It's a draw!")
        }
    }

    //! get the opposing piece (X or O)
    var opposingPlayer: Int {
      return self.currentPlayer == Game.PlayerX ? Game.PlayerO : Game.PlayerX
    }

    // the minmax algorithm to recursively determine the best move
    private func alphabeta( board: Board, depth: Int, alpha: inout Int, beta: inout Int, turn: Int) -> Int {

        if board.hasWon(player: self.currentPlayer) {
            return 1
        }

        if board.hasWon(player: self.opposingPlayer) {
            return -1
        }

        let pointsAvailable = board.availablePoints()

        if pointsAvailable.count == 0 {
            return 0
        }

        var imin = 2
        var imax = -2

        let oppositePlayer = turn == Game.PlayerX ? Game.PlayerO : Game.PlayerX
 
        for point in pointsAvailable {  

            if (!board.placeMove(point: point, player: oppositePlayer )) {
                continue
            }

            let val = alphabeta(board: board, depth: depth + 1, alpha: &alpha, beta: &beta, turn: oppositePlayer)

            if val > imax {
                imax = val
                beta = imax
            }

            if turn == self.opposingPlayer {
                if val > imax {
                    imax = val
                    beta = imax
                }
                if val == 1 || imax >= alpha {
                    break
                }
            } else {
                if val < imin {
                    imin = val
                    alpha = imin
                }
                if val == -1 || imin <= beta {
                    break
                }
            }
        } 
        return (turn == self.opposingPlayer) ? imax : imin
    }

    //! handy function to print a line for the board
    private func printLine(length: Int, leftCorner: String = "+", rightCorner: String = "+", interval: String = "-") {
        print(leftCorner, terminator:"")
        for i in 0...length-3 {
            if (i+1) % 4 == 0 {
                print(interval, terminator:"")
            } else {
                print("─", terminator:"")
            }
        }
        print(rightCorner)
    }

}
