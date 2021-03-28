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

    class func parse(str: String) -> Point? {
        // split on space and '-'
          let coords = str.split { $0 == Character(" ") || $0 == Character("-") }.map { String($0) }

          if coords.count < 2 {
              return nil
          }

          let x = Int(coords[0])
          let y = Int(coords[1])

          if x == nil || y == nil {
              return nil
          }

          if x! < 1 || x! > 3 || y! < 1 || y! > 3 {
              return nil
          }

          return Point(x: x! - 1, y: y! - 1)
    }
}


