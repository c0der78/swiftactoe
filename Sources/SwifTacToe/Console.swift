#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

class Console: InputSource, OutputSource {

    // MARK: Input Methods

    // read a line from input
    // hard to believe straight swift has not much for this
    internal func readln() -> String? {
      var cstr: [UInt8] = []
      var c: Int32 = 0
      while c != 4 {
          c = getchar()
          if c == 10 || c > 255 { break }
          cstr.append(UInt8(c))
      }
        // always add trailing zero
      cstr.append(0)

      return String(cString: &cstr)
  }

  // read a point from input
  func readMove() -> Point? {
      if let str = readln() {
          return Point.parse(str: str)
      }
      return nil
  }
  
  // MARK: Output Methods

  func promptMove() {
    print("Your move: ", terminator:"")
  }
}

class ConsoleIO : Console, IO {

  // read a player from input
  func readTile() -> Int? {
      guard let str = readln() else {
        return nil
      }
      switch str[str.startIndex].lowercased() {
      case "x":
        return Player.X
      case "o":
        return Player.O
      default:
        return nil
      }
  }

  func readYesNo() -> Bool? {
    guard let str = readln() else { return nil }
    switch str[str.startIndex].lowercased() {
    case "y":
      return true
    default:
      return false 
    }
  }

  func readNetworkType() -> Bool? {
    guard let str = readln() else { return nil }

    switch str.lowercased() {
    case "host":
      return false
    case "connect":
      return true 
    default:
      return nil 
    }
  }

  func readNetworkAddress() -> String? {
    return readln()
  }

  // MARK: Output Methods

  private func reset() {
      print("\u{1B}[9A\u{1B}[J", terminator: "")
  }

  func promptTile() {
    print("Do you want to be X or O (X goes first)? ", terminator: "")
  }

  func promptNetwork() {
    print("Start a network game? ", terminator: "")
  }

  func promptNetworkType() {
    print("Host or connect to a game? ", terminator: "")
  }

  func promptNetworkAddress() {
    print("Enter the network address to connect to: ", terminator: "")
  }

  func errorHint(_ message: String) {
    print("\u{1B}[A\r\u{1B}[2K${message}  ", terminator: "")
  }

  //! display the board to output
  func draw(board: Board) {
      self.reset()

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
                  case Player.O:
                      print(" \u{1B}[1;31mO ", terminator:"")
                      break;
                  case Player.X:
                      print(" \u{1B}[1;35mX ", terminator:"")
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

  func draw(finish: Bool?) {
    guard let won = finish else {
      print("It is a draw!")
      return
    }

    if won {
      print("You win!")
    } else {
      print("You lose!")
    }
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
