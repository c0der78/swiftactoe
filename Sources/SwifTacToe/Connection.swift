import Nanomsg

class Connection {
  internal var sock: Socket
  internal var eid: Int? = nil
  internal var buffer = String()

  enum Err: Error {
    case receive(Error)
    case send(Error)
    case bind(Error)
    case connect(Error)
  }

  init() throws {
    self.sock = try Socket(domain: .AF_SP, proto: .PAIR)
  }

  var isConnected: Bool {
    return self.eid != nil
  }

  private func receive(flags: Flags = .None) throws -> String {
    do {
      let value: String = try self.sock.recv()
      logger.trace { "received \(value)" }
      return value
    } catch {
      throw Err.receive(error)
    }
  }

  private func send(_ value: String, flags: Flags = .None) throws -> Bool {
    do {
      logger.trace { "sending \(value)" }
      let nBytes = try self.sock.send(value)
      return Int(nBytes) >= value.utf8.count
    } catch {
      throw Err.send(error)
    }
  }

  func sendln(_ value: String, flags: Flags = .None) throws {
    _ = try self.send("\(value)\n", flags: flags)
  }

  func connect(_ addr: String) throws {
    do {
      self.eid = try self.sock.connect(addr)
      self.sock.rcvtimeo = -1
      self.sock.sndtimeo = -1
    } catch {
      throw Err.connect(error)
    }
  }

  func bind(_ addr: String) throws {
    do {
      self.eid = try self.sock.bind(addr)
      self.sock.rcvtimeo = -1
      self.sock.sndtimeo = -1
    } catch {
      throw Err.bind(error)
    }
  }

  internal func readln(flags: Flags = .None) throws -> String? {
    var buf = String(self.buffer)

    self.buffer = String()

    while self.isConnected {
      let value: String = try self.receive(flags: flags)

      guard let pos = value.firstIndex(of: "\n") else {
        buf.append(value)
        continue
      }

      var str = value.prefix(upTo: pos)
      buf.append(contentsOf: str)
      str = value.suffix(from: pos)
      self.buffer.append(contentsOf: str)
      break
    }

    return buf
  }
}
