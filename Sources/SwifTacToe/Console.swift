class Console: InputSource, OutputSource {
  internal var outputBuf = [String]()

  // MARK: Input Methods

  // read a line from input
  // hard to believe straight swift has not much for this
  internal func readln() -> String {
    var cstr: [UInt8] = []
    var c: Int32 = 0
    while c != 4 {
      c = readChar()
      if c == 10 || c > 255 { break }
      cstr.append(UInt8(c))
    }
    // always add trailing zero
    cstr.append(0)

    return String(cString: &cstr)
  }

  // read a point from input
  func readMove() throws -> Point? {
    logger.trace { "reading player move" }
    let str = readln()
    return Point.parse(str: str.trim())
  }

  func buffer(_ message: String) {
    self.outputBuf.append(message)
  }

  // MARK: Output Methods

  func promptMove() {
    logger.trace { "prompting player move" }
    self.buffer("Your move: ")
  }
}

class ConsoleIO: Console, IO {

  override init() {
    print("\u{1B}[f\u{1B}[2J", terminator: "")
  }

  // read a player from input
  func readTile() throws -> Tile? {
    let str = readln()
    return Tile.parse(str.trim())
  }

  // MARK: Output Methods

  private func reset() {
    print("\u{1B}[H\u{1B}[2J", terminator: "")
  }

  func promptTile() {
    print("Do you want to be X or O (X goes first)? ", terminator: "")
  }

  func output(board: Board) {

    self.reset()

    self.draw(board: board)

    if !super.outputBuf.isEmpty {
      print(super.outputBuf.removeLast(), terminator: "")
    }
    flush()
  }

  //! display the board to output
  func draw(board: Board) {

    // dislay the y coords
    print("\u{1B}[0m", terminator: "")
    print("  y 1   2   3")

    // draw the top of the board
    printLine(length: 13, leftCorner: "x \u{1B}[1;37m┌", rightCorner: "┐", interval: "┬")

    for i in 0...board.size - 1 {
      // draw each line
      print("\u{1B}[0m\(i+1) ", terminator: "")

      for j in 0...board.size - 1 {

        print("\u{1B}[1;37m\u{2502}\u{1B}[1;33m", terminator: "")

        switch board[i, j] {
        case Player.o:
          print(" \u{1B}[1;31mO ", terminator: "")
          break
        case Player.x:
          print(" \u{1B}[1;35mX ", terminator: "")
          break
        default:
          print("   ", terminator: "")
          break
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

  //! handy function to print a line for the board
  private func printLine(
    length: Int, leftCorner: String = "+", rightCorner: String = "+", interval: String = "-"
  ) {
    print(leftCorner, terminator: "")
    for i in 0...length - 3 {
      if (i + 1) % 4 == 0 {
        print(interval, terminator: "")
      } else {
        print("─", terminator: "")
      }
    }
    print(rightCorner)
  }

}
