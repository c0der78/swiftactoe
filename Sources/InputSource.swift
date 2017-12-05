#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

protocol InputSource {
	func readPoint() -> Point?
	func readPlayer() -> Int?
}

class Console: InputSource {

    // read a line from input
    // hard to believe straight swift has not much for this
    private func readln() -> String? {
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

  // read a player from input
  func readPlayer() -> Int? {
      if let str = readln() {
        let c = str[str.startIndex]

          if c == "X" || c == "x" {
            return Game.PlayerX
          } else if c == "O" || c == "o" {
            return Game.PlayerO
          }
      }
      return nil
  }

  // read a point from input
  func readPoint() -> Point? {
      if let str = readln() {
          return Point.parse(str: str)
      }
      return nil
  }

}