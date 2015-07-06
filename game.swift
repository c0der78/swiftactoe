import Darwin;

class PointAndScore {

    var score: Int;
    var point: Point;

    init( score: Int, point: Point) {
        self.score = score;
        self.point = point;
    }
}

class Game
{

    static let PlayerX = 1;
    static let PlayerO = 2;
 
	private var board: Board;
	private var humanPlayer: Int;

	init(board: Board) {
		self.board = board;
		self.humanPlayer = 0;
	}


    var isGameOver: Bool {
        //Game is over is someone has won, or board is full (draw)
        return (board.hasWon(Game.PlayerX) || board.hasWon(Game.PlayerO) || board.availablePoints().count == 0);
    }

    func setHumanPlayerFromInput() -> Bool {
                
        let choice = readPlayer();

        if (choice == nil) {
        	return false;
        }

        self.humanPlayer = choice!;

        // do the computers first move
        if(self.humanPlayer == Game.PlayerO){
            let p = Point(x: Int(arc4random_uniform(3)), y: Int(arc4random_uniform(3)));
            b.placeMove(p, player: self.computerPlayer);
        }

        return true;
    }

    func placeHumanMoveFromInput() -> Bool {
        print("Your move: ", appendNewline:false);

        let userMove = readPoint();

        if (userMove == nil) {
            print("\u{1B}[A\r\u{1B}[2KInvalid point.  Try 'x-y' or 'x y'.  ", appendNewline: false);
            return false;
        }

        if (!b.placeMove(userMove!, player: self.humanPlayer) ) { //2 for O and O is the user
            print("\u{1B}[A\r\u{1B}[2KThat move is already taken.  ", appendNewline: false);
            return false;
        }

        return true;
    }

    func placeComputerMove() -> Bool {

        if (isGameOver) { 
        	return false; 
        }

        let pointsAvailable = board.availablePoints();

        if (pointsAvailable.count == 0) {
            return false; 
        }

        var move: Point?;
        var imin: Int = 2;

        for point in pointsAvailable {

            if(!board.placeMove(point, player: self.computerPlayer)) {
                continue;
            }

            let val = minmax(0, turn: self.computerPlayer, alpha: 2, beta: -2); 

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
            return board.placeMove(move!, player: self.computerPlayer);
        }

        return false;
    }


    func displayBoard() {

        print("\u{1B}[0m  y 1   2   3");

        printLine(13, leftCorner: "x \u{1B}[1;37m┌", rightCorner: "┐", interval: "┬");

        for var i = 0; i < board.size; i++ {
            
            print("\u{1B}[0m\(i+1) ", appendNewline: false);

            for var j = 0; j < board.size; j++ {

                print("\u{1B}[1;37m\u{2502}\u{1B}[1;33m", appendNewline: false);

                switch(board[i, j]) {
                    case Game.PlayerO:
                        print(" ◯ ", appendNewline:false);
                        break;
                    case Game.PlayerX:
                        print(" ╳ ", appendNewline:false);
                        break;
                    default:
                        print("   ", appendNewline:false);
                        break;
                }
            }
            
            print("\u{1B}[1;37m│");

            if ((i + 1) != board.size) {
                printLine(13, leftCorner: "  \u{1B}[1;37m├", rightCorner: "┤", interval: "┼");
            }
        }

        printLine(13, leftCorner: "  \u{1B}[1;37m└", rightCorner: "┘\u{1B}[0m", interval: "┴");
    } 

    func displayWinner() {

		if (board.hasWon(self.humanPlayer)) { 
		    print("You win!"); //Can't happen
		} else if (board.hasWon(self.computerPlayer)) {
		    print("Unfortunately, you lost!");
		} else {
		    print("It's a draw!");
		}

    }

    var computerPlayer: Int {
    	return self.humanPlayer == Game.PlayerX ? Game.PlayerO : Game.PlayerX
    }

    private func minmax( depth: Int, turn: Int, var alpha: Int, var beta: Int) -> Int {  

        if (board.hasWon(self.humanPlayer)) { 
            return 1; 
        }

        if (board.hasWon(self.computerPlayer)) { 
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

                if (!board.placeMove(point, player: self.humanPlayer)) {
                    board[point.x, point.y] = 0;
                    continue;
                }

                let val = minmax(depth + 1, turn: self.humanPlayer, alpha: alpha, beta: beta);

                if (val > imax) {
                    imax = val;
                    beta = imax;
                }
                
                if (val == 1 || imax >= alpha) {
                    board[point.x, point.y] = 0;
                    break;
                }

            } else if (turn == self.humanPlayer) {

                if (!board.placeMove(point, player: self.computerPlayer)) {
                    board[point.x, point.y] = 0;
                    continue;
                }

                let val = minmax(depth + 1, turn: self.computerPlayer, alpha: alpha, beta: beta);

				if (val < imin) {
                    imin = val;
                    alpha = imin;
                }

                if (val == -1 || imin <= beta) {
                    board[point.x, point.y] = 0;
                    break;
                }

            }

            board[point.x, point.y] = 0;
        } 
        
        return (turn == self.computerPlayer) ? imax : imin;
    }  
    
    private func printLine(length: Int, leftCorner: String = "+", rightCorner:String = "+", interval:String = "-") {
        print(leftCorner,  appendNewline:false);
        for i in 0...length-3 {
            if ((i+1) % 4 == 0) {
                print(interval, appendNewline:false);
            } else {
                print("─",  appendNewline:false)
            }
        }
        print(rightCorner);
    }


	private func readln() -> String? {
	    var cstr: [UInt8] = []
	    var c: Int32 = 0
	    while c != 4 {
	        c = getchar()
	        if (c == 10 || c == 13) || c > 255 { break }
	        cstr.append(UInt8(c))
	    }
	    cstr.append(0)

	    let rval = String.fromCStringRepairingIllFormedUTF8(UnsafePointer<CChar>(cstr))

	    if (rval.hadError) {
	        return nil;
	    }

	    return rval.0;
	}

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

	private func readPoint() -> Point? {
	    if let str = readln() {

	        var coords = split(str.characters) { $0 == Character(" ") || $0 == Character("-") }.map{ String($0) }

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