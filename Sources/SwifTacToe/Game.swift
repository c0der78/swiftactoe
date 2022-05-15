class Game {
  private var io: IO
  private var board: Board
  private var opponent: Player?
  private var network: Network?

  internal var player: Player

  var currentPlayer: Player?

  enum Err: Error {
    case state(String)
    case setup(String)
    case parsing(String)
  }

  init() {
    self.board = Board()
    self.io = ConsoleIO()
    self.player = Player(input: self.io, output: self.io)
  }

  var isGameOver: Bool {
    //Game is over is someone has won, or board is full (draw)
    return (board.hasWon(Player.x) || board.hasWon(Player.o) || board.availableMoves().count == 0)
  }

  func setup() throws {
    var opponent: Player

    if let network = self.network {

      opponent = Player(network: network)

      switch network.type {
      case .joining:

        guard let choice = try network.readTile() else {
          throw Err.parsing("player joining game")
        }

        self.player.tile = choice

      case .hosting:
        try self.readTileChoice()

        opponent.output?.promptMove()
        self.io.output(board: board)

        try network.sendln(self.player.tile.opposite.description)
      }
    } else {

      opponent = Bot(self.board, self.io)

      try self.readTileChoice()
    }

    opponent.tile = self.player.tile.opposite

    self.opponent = opponent
    self.currentPlayer = self.player.isFirst ? self.player : self.opponent
  }

  private func readTileChoice() throws {
    self.io.promptTile()

    guard let choice = try self.io.readTile() else {
      self.io.buffer("Invalid move.  Try x y coordinates.")
      throw Err.parsing("reading player")
    }

    self.player.tile = choice
  }

  func startNetwork(type: NetworkType, address: String) throws {
    let network = try Network(type, self.io)

    try network.start(addr: address)

    self.network = network
  }

  private func isPlayerTurn(_ turn: Player? = nil) -> Bool {
    return (turn ?? self.currentPlayer) == self.player
  }

  func update() throws {
    logger.trace { "update" }
    guard let player = self.currentPlayer else {
      throw Err.state("no current player")
    }

    guard let point = try player.input?.readMove() else {
      throw Err.parsing("reading move")
    }

    if !self.board.placeMove(point: point, player: player.tile) {
      if self.isPlayerTurn(player) {
        self.io.buffer("Location already taken!")
      }
      return
    }

    logger.trace { "\(player.tile) moved \(point.description)" }

    if self.isPlayerTurn(player) {
      try self.network?.update(move: point)
    }

    if self.currentPlayer == self.player {
      self.currentPlayer = self.opponent
    } else {
      self.currentPlayer = self.player
    }
    logger.trace { "player is now \(self.currentPlayer!.tile)" }
  }

  func render() throws {
    logger.trace { "render" }
    self.currentPlayer?.output?.promptMove()

    self.io.output(board: self.board)
  }

  func finish() {

    if board.hasWon(self.player.tile) {
      self.io.buffer("\u{1B}[1;33mYou win!\u{1B}[0m")
    } else if let tile = self.opponent?.tile, board.hasWon(tile) {
      self.io.buffer("It is a \u{1B}[1;38mdraw!\u{1B}[0m")
    } else {
      self.io.buffer("\u{1B}[1;31mYou lose!\u{1B}[0m")
    }

    self.io.output(board: self.board)
  }
}
