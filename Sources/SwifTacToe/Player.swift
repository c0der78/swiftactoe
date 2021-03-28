
typealias Tile = Int 

class Player {
  static let X: Tile = 1
  static let O: Tile = 2

  var tile: Tile = 0 

  weak var input: InputSource?
  weak var output: OutputSource?

  init(input: InputSource?, output: OutputSource?) {
    self.input = input
    self.output = output
  }

  init() {}

  var isFirst: Bool { return self.tile == Player.X }
}

func == (a: Player, b: Player) -> Bool {
  return a.tile == b.tile
}

func == (a: Optional<Player>, b: Player) -> Bool {
  guard let tile = a?.tile else { return false }
  return tile == b.tile 
}

func == (a: Player, b: Tile) -> Bool {
  return a.tile == b
}
