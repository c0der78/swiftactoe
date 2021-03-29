class Point {

  var x: Int
  var y: Int

  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }

  var description: String {
    return "[\(x), \(y)]"
  }

  static func parse(str: String) -> Point? {
    logger.trace { "parsing point \(str)" }

    // split on space and '-'
    let coords = str.split { " -\t".contains($0) }.map { String($0) }

    if coords.count < 2 {
      return nil
    }

    guard let x = Int(coords[0]), let y = Int(coords[1]) else {
      return nil
    }

    if x < 1 || x > 3 || y < 1 || y > 3 {
      return nil
    }

    return Point(x: x - 1, y: y - 1)
  }
}
