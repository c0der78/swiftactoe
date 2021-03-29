typealias Tile = Character

extension Tile {
  static var none: Tile = Tile("?")

  static func parse(_ str: String) -> Tile? {
    switch str[str.startIndex].lowercased() {
    case "x":
      return Player.x
    case "o":
      return Player.o
    default:
      return nil
    }
  }
  var opposite: Tile {
    switch self {
    case Player.x:
      return Player.o
    case Player.o:
      return Player.x
    default:
      return Tile("?")
    }
  }
}

class Player {
  static let x: Tile = Tile("X")
  static let o: Tile = Tile("O")

  var tile: Tile = Tile.none

  weak var input: InputSource?
  weak var output: OutputSource?

  init(input: InputSource?, output: OutputSource?) {
    self.input = input
    self.output = output
  }

  convenience init(network: Network) {
    self.init(input: network, output: network)
  }

  init() {}

  var isFirst: Bool { return self.tile == Player.x }
}

func == (a: Player, b: Player) -> Bool {
  return a.tile == b.tile
}

func == (a: Player?, b: Player) -> Bool {
  guard let tile = a?.tile else { return false }
  return tile == b.tile
}

func == (a: Player, b: Tile) -> Bool {
  return a.tile == b
}
