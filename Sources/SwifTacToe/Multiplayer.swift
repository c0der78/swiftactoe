#if os(Linux)
import Glibc
#else
import Darwin
#endif
import Nanomsg

class Multiplayer {
    internal var sock: Socket
    var isConnected: Bool

    init(proto: Proto) throws {
        sock = try Socket(proto)
        self.isConnected = false
    }

    func recieve() -> String? {
      if !self.isConnected {
        return nil
      }
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
      if !self.isConnected {
        return false
      }
      do {
        let nBytes = try sock.send(value)
        return Int(nBytes) == value.count
      } catch _ {
        return false
      }
    }
}

