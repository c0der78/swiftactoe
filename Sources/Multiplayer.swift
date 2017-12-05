#if os(Linux)
import Glibc
#else
import Darwin
#endif
import Nanomsg

class Multiplayer {
    internal var game: Game
    internal var sock: Socket

    init(game: Game, proto: Proto) throws {
        sock = try Socket(proto)
        self.game = game
    }

    func recieve() -> String? {
      do {
        sock.rcvtimeo = 100
        let buf = try sock.recv()
        return String(cString: buf.baseAddress!)
      } catch NanomsgError.Err(let errno, _) {
          // timeout
          assert(errno == 60)

          return nil
      } catch _ {
        return nil
      }
    }

    func send(value: String) -> Bool {
      do {
        let nBytes = try sock.send(value)
        return Int(nBytes) == value.characters.count
      } catch _ {
        return false
      }
    }
}

class Client: Multiplayer, InputSource {

    init(game: Game) throws {
      try super.init(game: game, proto: .SUB)
    }

    func connect(addr: String) -> Bool {
        do {
            if game.currentPlayer == Game.PlayerX {
                let eid = try sock.bind(addr)
                return eid != 0
            } else {
                let eid = try sock.connect(addr)
                return eid != 0
            }
        } catch _ {
            return false
        }
    }

    private func readln() -> String? {

      var buf: String = String()

      while(true) {
            let line = recieve()
            if (line == nil) {
              return nil;
            }
            let pos = line!.characters.index(of: "\n")
            if (pos != nil) {
              let str = line!.characters.prefix(upTo: pos!)
              buf.append(String(str));
              return buf;
            } else {
              buf.append(line!)
            }
        }
    }

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

    func readPoint() -> Point? {
        if let str = recieve() {
            return Point.parse(str: str)
        }
        return nil
    }
}
