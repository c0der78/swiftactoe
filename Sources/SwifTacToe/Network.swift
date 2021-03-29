enum NetworkType {
  case hosting
  case joining
}

class Network: Connection, InputSource, OutputSource {

  var type: NetworkType
  var io: IO

  init(_ type: NetworkType, _ io: IO) throws {
    self.type = type
    self.io = io
    try super.init()
  }

  func start(addr: String) throws {
    switch self.type {
    case .hosting:
      try super.bind(addr)
    case .joining:
      try super.connect(addr)
    }
  }

  func update(move: Point) throws {
    _ = try super.sendln("\(move.x + 1) \(move.y + 1)")
  }

  func readTile() throws -> Tile? {
    guard let str = try super.readln() else {
      return nil
    }
    return Tile.parse(str.trim())
  }

  func promptMove() {
    self.io.buffer("Waiting for opponent...")
  }

  func readMove() throws -> Point? {
    guard let str = try super.readln() else {
      return nil
    }

    return Point.parse(str: str.trim())
  }
}
