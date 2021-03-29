protocol IO: InputSource, OutputSource {
  func readTile() throws -> Tile?

  func promptTile()
  func buffer(_ message: String)

  func output(board: Board)
  func draw(board: Board)
}
