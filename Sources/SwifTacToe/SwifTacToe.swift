class SwifTacToe {

  let name = "SwifTacToe"
  let version = "v1.0.0"
  let description = "a game of tic tac toe"

  var networkAddr: String?
  var networkType: NetworkType?

  init() {
    parse()
  }

  private func parse() {
    while let opt = parseArgs("vhsja:") {
      switch opt.0 {
      case "v":
        eprint("\(name) \(version) \(description)")
        osexit(1)
      case "h":
        help()
        osexit(1)
      case "s":
        networkType = .hosting
      case "j":
        networkType = .joining
      case "a":
        networkAddr = opt.1
      default:
        break
      }
    }
  }

  private func help() {
    eprint("Syntax: \(name) [flags]\n")
    eprint("  -h      show this help")
    eprint("  -v      show the version")
    eprint("  -s      host a game")
    eprint("  -j      join a game")
    eprint("  -a      the game address\n")
    eprint("Examples:\n")
    eprint("  \(name) -s -a ipc:///tmp/pair.ipc   (host a local game)")
    eprint("  \(name) -j -a ipc:///tmp/pair.ipc   (join a local game)\n")
  }

  func execute() throws {

    let game = Game()

    if let type = self.networkType, let addr = self.networkAddr {
      try game.startNetwork(type: type, address: addr)
    }

    try game.setup()

    defer {
      game.finish()
    }

    repeat {
      try game.render()
      try game.update()
    } while !game.isGameOver
  }
}
