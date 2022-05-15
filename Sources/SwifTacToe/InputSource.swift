protocol InputSource: AnyObject {

  // read a point to place a move
  func readMove() throws -> Point?
}
