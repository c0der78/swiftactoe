
protocol IO: InputSource, OutputSource {
  func readTile() -> Int?
  func readNetworkType() -> Bool?
  func readNetworkAddress() -> String?
  func readYesNo() -> Bool?

  func errorHint(_ message: String)

  func promptNetwork()
  func promptNetworkType()
  func promptNetworkAddress()
  func promptTile()
  
  func draw(board: Board)
  func draw(finish: Bool?)
}

