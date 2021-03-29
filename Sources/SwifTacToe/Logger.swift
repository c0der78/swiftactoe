var logger = Logger()

#if DEBUG
typealias BitMask = UInt32

extension BitMask {
  func has(_ other: LogInfo) -> Bool {
    return self & other.mask != 0
  }
}

enum LogInfo: BitMask {
  case times
  case tags
  case files
  case lines
  case funcs

  var mask: BitMask {
    return (1 << rawValue)
  }
}

extension LogInfo {
  static func | (_ a: LogInfo, _ b: LogInfo) -> BitMask {
    return a.mask | b.mask
  }
  static func | (_ a: BitMask, _ b: LogInfo) -> BitMask {
    return a | b.mask
  }
}

class Logger {

  var level: Int = -1

  var features: BitMask = LogInfo.tags | LogInfo.times

  func trace(
    _ tag: String? = nil, lvl: Int = 1, _ file: String = #file, _ function: String = #function,
    _ line: Int = #line, message: @escaping () -> String
  ) {
    if lvl < self.level {
      return
    }

    let info = build(tag, file, function, line)

    print("\(info) \(message())", to: &errorStream)
  }

  private func build(_ tag: String?, _ file: String, _ function: String, _ line: Int) -> String {
    var values = [String]()

    if features.has(.times) {
      if let dateFormat = formatCurrentDateTime() {
        values.append(dateFormat)
      }
    }

    if let t = tag, features.has(.tags) {
      values.append(t)
    }

    if features.has(.files) {
      if features.has(.lines) {
        values.append("\(file):\(line)")
      } else {
        values.append(file)
      }
    }

    if features.has(.funcs) {
      values.append(function)
    }

    return values.joined()
  }
}
#else

class Logger {

  func trace(_ message: @escaping () -> String) {}
}
#endif
