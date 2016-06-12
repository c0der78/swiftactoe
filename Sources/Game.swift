#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

class Game
{
    // the player X/O defines
    static let PlayerX = 1;
    static let PlayerO = 2;
 
    private var board: Board;
    private var humanPlayer: Int;

    // need a board to start a isGameOver
    init(board: Board) {
      self.board = board;
      self.humanPlayer = 0;
    }

    var isGameOver: Bool {
        //Game is over is someone has won, or board is full (draw)
        return (board.hasWon(player: Game.PlayerX) || board.hasWon(player: Game.PlayerO) || board.availablePoints().count == 0);
    }

    //! reads input and determines human player (X or O)
    func setHumanPlayerFromInput() -> Bool {
        let choice = readPlayer();

        if (choice == nil) {
          return false;
        }

        self.humanPlayer = choice!;

        // do the computers first move
        if(self.humanPlayer == Game.PlayerO){
#if os(Linux)
	    let p = Point(x: Int(random() % 3), y: Int(random() % 3));
#else
            let p = Point(x: Int(arc4random_uniform(3)), y: Int(arc4random_uniform(3)));
#endif
       	    if(!b.placeMove(point: p, player: self.computerPlayer)) {
		return false;
	    }
        }

        return true;
    }

    // reads a point from input and makes a move if available
    func placeHumanMoveFromInput() -> Bool {
        print("Your move: ", terminator:"");

        let userMove = readPoint();

        // will use VT100 to replace the last line for error messages

        if (userMove == nil) {
            print("\u{1B}[A\r\u{1B}[2KInvalid point.  Try 'x-y' or 'x y'.  ", terminator:"");
            return false;
        }

        if (!b.placeMove(point: userMove!, player: self.humanPlayer) ) { //2 for O and O is the user
            print("\u{1B}[A\r\u{1B}[2KThat move is already taken.  ", terminator:"");
            return false;
        }

        return true;
    }

    //! calculate a computer move and place
    func placeComputerMove() -> Bool {

        if (isGameOver) { 
          return false; 
        }

        // get a list of available moves
        let pointsAvailable = board.availablePoints();

        // no more moves?
        if (pointsAvailable.count == 0) {
            return false; 
        }

        var move: Point?;
        var imin: Int = 2;
	let alpha = 2;
	let beta = -2;

        // find the best move
        for point in pointsAvailable {

            if(!board.placeMove(point: point, player: self.computerPlayer)) {
                continue;
            }

            let val = minmax(depth: 0, turn: self.computerPlayer, alpha: alpha, beta: beta); 

            board[point.x, point.y] = 0;

            if (imin > val) {
                imin = val;
                move = point;
            } 

            if (val == -1) {
                break;
            }
        }

        if (move != nil) {
            return board.placeMove(point: move!, player: self.computerPlayer);
        }

        return false;
    }


    //! display the board to output
    func displayBoard() {

        // dislay the y coords
        print("\u{1B}[0m  y 1   2   3");

        // draw the top of the board
        printLine(length: 13, leftCorner: "x \u{1B}[1;37m┌", rightCorner: "┐", interval: "┬");


        for i in 0...board.size-1 {
            // draw each line
            print("\u{1B}[0m\(i+1) ", terminator:"");

            for j in 0...board.size-1 {

                print("\u{1B}[1;37m\u{2502}\u{1B}[1;33m", terminator:"");

                switch(board[i, j]) {
                    case Game.PlayerO:
                        print(" ◯ ", terminator:"");
                        break;
                    case Game.PlayerX:
                        print(" ╳ ", terminator:"");
                        break;
                    default:
                        print("   ", terminator:"");
                        break;
                }
            }
            print("\u{1B}[1;37m│");

            if ((i + 1) != board.size) {
                printLine(length: 13, leftCorner: "  \u{1B}[1;37m├", rightCorner: "┤", interval: "┼");
            }
        }

        // draw the bottom border
        printLine(length: 13, leftCorner: "  \u{1B}[1;37m└", rightCorner: "┘\u{1B}[0m", interval: "┴");
    } 

    //! display the game status
    func displayWinner() {
        if (board.hasWon(player: self.humanPlayer)) { 
            print("You win!"); //Can't happen
        } else if (board.hasWon(player: self.computerPlayer)) {
            print("Unfortunately, you lost!");
        } else {
            print("It's a draw!");
        }
    }

    //! get the opposing piece (X or O)
    var computerPlayer: Int {
      return self.humanPlayer == Game.PlayerX ? Game.PlayerO : Game.PlayerX
    }

    // the minmax algorithm to recursively determine the best move
    private func minmax( depth: Int, turn: Int, alpha: Int, beta: Int) -> Int {  
	
	var alphaVal = alpha;
	var betaVal = beta;

        if (board.hasWon(player: self.humanPlayer)) { 
            return 1; 
        }

        if (board.hasWon(player: self.computerPlayer)) { 
            return -1; 
        }

        let pointsAvailable = board.availablePoints();

        if (pointsAvailable.count == 0) {
            return 0; 
        }

        var imin = 2;
        var imax = -2;
 
        for point in pointsAvailable {  

            if (turn == self.computerPlayer) { 

                if (!board.placeMove(point: point, player: self.humanPlayer)) {
                    board[point.x, point.y] = 0;
                    continue;
                }

                let val = minmax(depth: depth + 1, turn: self.humanPlayer, alpha: alphaVal, beta: betaVal);

                if (val > imax) {
                    imax = val;
                    betaVal = imax;
                }
                if (val == 1 || imax >= alphaVal) {
                    board[point.x, point.y] = 0;
                    break;
                }

            } else if (turn == self.humanPlayer) {

                if (!board.placeMove(point: point, player: self.computerPlayer)) {
                    board[point.x, point.y] = 0;
                    continue;
                }

                let val = minmax(depth: depth + 1, turn: self.computerPlayer, alpha: alphaVal, beta: betaVal);

                if (val < imin) {
                    imin = val;
                    alphaVal = imin;
                }

                if (val == -1 || imin <= betaVal) {
                    board[point.x, point.y] = 0;
                    break;
                }

            }

            board[point.x, point.y] = 0;
        } 
        return (turn == self.computerPlayer) ? imax : imin;
    }

    //! handy function to print a line for the board
    private func printLine(length: Int, leftCorner: String = "+", rightCorner:String = "+", interval:String = "-") {
        print(leftCorner,  terminator:"");
        for i in 0...length-3 {
            if ((i+1) % 4 == 0) {
                print(interval, terminator:"");
            } else {
                print("─",  terminator:"")
            }
        }
        print(rightCorner);
    }


    // read a line from input
    // hard to believe straight swift has not much for this
    private func readln() -> String? {
      var cstr: [UInt8] = []
      var c: Int32 = 0
      while c != 4 {
          c = getchar()
          if (c == 10 || c == 13) || c > 255 { break }
          cstr.append(UInt8(c))
      }
        // always add trailing zero
      cstr.append(0)

      return String.init(cString: UnsafePointer<CChar>(cstr))
  }

    // read a player from input
  private func readPlayer() -> Int? {
      if let str = readln() {
        let c = str[str.startIndex]

          if c == "X" || c == "x" {
            return Game.PlayerX;
          } else if c == "O" || c == "o" {
            return Game.PlayerO;
          }
      }
      return nil;
  }

    // read a point from input
  private func readPoint() -> Point? {
      if let str = readln() {

            // split on space and '-'
          var coords = str.characters.split { $0 == Character(" ") || $0 == Character("-") }.map{ String($0) }

          if (coords.count < 2) {
              return nil;
          }

          let x = Int(coords[0]);
          let y = Int(coords[1]);

          if (x == nil || y == nil) {
              return nil;
          }

          if (x < 1 || x > 3 || y < 1 || y > 3) {
              return nil;
          }

          return Point(x: x! - 1, y: y! - 1);
      }
      return nil;
  }

}
