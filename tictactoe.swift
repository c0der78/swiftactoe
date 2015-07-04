import Darwin;

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

class PointAndScore {

    var score: Int;
    var point: Point;

    init( score: Int, point: Point) {
        self.score = score;
        self.point = point;
    }
}

func readln() -> String? {
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

func readInt() -> Int? {
    if let str = readln() {
        return Int(str);
    }
    return nil;
}

func readPoint() -> Point? {
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
    
class Board {
 
    var computersMove: Point?; 
    
    var availablePoints: [Point];
    
    var board: [[Int]];

    init() {
        board = [[0,0,0],[0,0,0],[0,0,0]];
        availablePoints = [];
        computersMove = nil;
    }

    var isGameOver: Bool {
        //Game is over is someone has won, or board is full (draw)
        return (self.hasXWon || self.hasOWon || self.availableStates().count == 0);
    }

    var hasXWon: Bool {
        if ((board[0][0] == board[1][1] && board[0][0] == board[2][2] && board[0][0] == 1) || (board[0][2] == board[1][1] && board[0][2] == board[2][0] && board[0][2] == 1)) {
            //System.out.println("X Diagonal Win");
            return true;
        }
        for (var i = 0; i < board.count; ++i) {
            if (((board[i][0] == board[i][1] && board[i][0] == board[i][2] && board[i][0] == 1)
                    || (board[0][i] == board[1][i] && board[0][i] == board[2][i] && board[0][i] == 1))) {
                // System.out.println("X Row or Column win");
                return true;
            }
        }
        return false;
    }

    var hasOWon: Bool {
        if ((board[0][0] == board[1][1] && board[0][0] == board[2][2] && board[0][0] == 2) || (board[0][2] == board[1][1] && board[0][2] == board[2][0] && board[0][2] == 2)) {
            // System.out.println("O Diagonal Win");
            return true;
        }
        for (var i = 0; i < board.count; ++i) {
            if ((board[i][0] == board[i][1] && board[i][0] == board[i][2] && board[i][0] == 2)
                    || (board[0][i] == board[1][i] && board[0][i] == board[2][i] && board[0][i] == 2)) {
                //  System.out.println("O Row or Column win");
                return true;
            }
        }

        return false;
    }

    func availableStates() -> [Point] {
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

    func placeAMove(point: Point, player: Int) -> Bool {
        if (self.board[point.x][point.y] != 0) {
            return false;
        }
        self.board[point.x][point.y] = player;   //player = 1 for X, 2 for O
        return true;
    } 

    func takeHumanInput() -> Bool {
        print("Your move: ", appendNewline:false);

        let userMove = readPoint();

        if (userMove == nil) {
            print("\u{1B}[A\r\u{1B}[2KInvalid point.  Try 'x-y' or 'x y'.  ", appendNewline: false);
            return false;
        }

        if (!b.placeAMove(userMove!, player: 2) ) { //2 for O and O is the user
            print("\u{1B}[A\r\u{1B}[2KThat move is already taken.  ", appendNewline: false);
            return false;
        }

        return true;
    }


    func printLine(length: Int, leftCorner: String = "+", rightCorner:String = "+", interval:String = "-") {
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

    func displayBoard() {

        print("\u{1B}[0m  y 1   2   3");

        printLine(13, leftCorner: "x \u{1B}[1;37m┌", rightCorner: "┐", interval: "┬");

        for var i = 0; i < board.count; i++ {
            
            print("\u{1B}[0m\(i+1) ", appendNewline: false);

            for var j = 0; j < board[i].count; j++ {

                print("\u{1B}[1;37m\u{2502}\u{1B}[1;33m", appendNewline: false);

                switch(board[i][j]) {
                    case 1:
                        print(" ◯ ", appendNewline:false);
                        break;
                    case 2:
                        print(" ╳ ", appendNewline:false);
                        break;
                    default:
                        print("   ", appendNewline:false);
                        break;
                }
            }
            
            print("\u{1B}[1;37m│");

            if ((i + 1) != board.count) {
                printLine(13, leftCorner: "  \u{1B}[1;37m├", rightCorner: "┤", interval: "┼");
            }
        }

        printLine(13, leftCorner: "  \u{1B}[1;37m└", rightCorner: "┘\u{1B}[0m", interval: "┴");
    } 
    
    func minimax( depth: Int, turn: Int) -> Int {  
        if (self.hasXWon) { return +1; }
        if (self.hasOWon) { return -1; }

        var pointsAvailable = availableStates();

        if (pointsAvailable.count == 0) {
            return 0; 
        }
 
        var imin = Int.max;
        var imax = Int.min;
         
        for (var i = 0; i < pointsAvailable.count; ++i) {  
            let point = pointsAvailable[i]; 

            if (turn == 1) { 
                placeAMove(point, player: 1); 
                let currentScore = minimax(depth + 1, turn: 2);
                imax = max(currentScore, imax);
                
                if(currentScore >= 0){ 
                    if(depth == 0) { 
                        computersMove = point; 
                    }
                }  
                if(currentScore == 1){ 
                    board[point.x][point.y] = 0; 
                    break;
                } 
                if(i == pointsAvailable.count-1 && imax < 0) {
                    if(depth == 0) { 
                        computersMove = point;
                    } 
                }
            } else if (turn == 2) {
                placeAMove(point, player: 2); 
                let currentScore = minimax(depth + 1, turn: 1);
                imin = min(currentScore, imin); 
                if(imin == -1){
                    board[point.x][point.y] = 0; 
                    break;
                }
            }
            board[point.x][point.y] = 0; //Reset this point
        } 
        return (turn == 1) ? imax : imin;
    }  
}
