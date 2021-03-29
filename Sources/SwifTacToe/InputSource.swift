protocol InputSource: class {

  // read a point to place a move
  func readMove() throws -> Point?
}
