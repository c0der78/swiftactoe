class Client: Multiplayer, InputSource {

    init() throws {
      try super.init(proto: .SUB)
    }

    func connect(addr: String) -> Bool {
        do {
            let eid = try sock.connect(addr)
            super.isConnected = eid != 0
            return eid != 0
        } catch _ {
            return false
        }
    }

    private func readln() -> String? {

      if !super.isConnected {
        return nil 
      }

      var buf: String = String()

      while(true) {
            guard let line = recieve() else { return nil }
            let pos = line.firstIndex(of: "\n")
            if (pos != nil) {
              let str = line.prefix(upTo: pos!)
              buf.append(contentsOf: str)
              return buf
            } else {
              buf.append(line)
            }
        }
    }

    func readMove() -> Point? {
        if let str = recieve() {
            return Point.parse(str: str)
        }
        return nil
    }
}

