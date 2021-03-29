#if os(Linux)
  import Glibc
#else
  import Darwin
#endif

var errorStream = ErrorOutputStream()
var nullStream = NullOutputStream()

func osexit(_ status: Int32) {
  exit(status)
}

extension String {
  static let trimmable = " \t\n\r"

  func trim() -> String {
    let first = self.firstIndex(where: { !String.trimmable.contains($0) })
    let last = self.lastIndex(where: { !String.trimmable.contains($0) })

    if first == nil && last == nil {
      return self
    }

    if let f = first {
      if let l = last {
        return String(self[f...l])
      } else {
        return String(self[f...])
      }
    } else if let l = last {
      return String(self[...l])
    }

    return self
  }
}

func parseArgs(_ options: String) -> (Character, String?)? {
  let value: Int32 = getopt(CommandLine.argc, CommandLine.unsafeArgv, options)

  if value < 0 {
    return nil
  }

  if let unicodeValue = UnicodeScalar(UInt32(value)) {

    let c = Character(unicodeValue)

    if options.contains(c) {

      var arg: String? = nil

      if optarg != nil {
        arg = String(cString: optarg)
      }

      return (c, arg)
    }
  }

  return nil
}

func wait(seconds: UInt32) {
  usleep(seconds * 1_000_000)
}

func wait(millis: UInt32) {
  usleep(millis * 1000)
}

func readChar() -> Int32 {
  return getchar()
}

func eprint(_ items: String) {
  print(items, to: &errorStream)
}

func flush() {
  fflush(stderr)
  fflush(stdout)
}

func formatCurrentDateTime() -> String? {
  var now = time(nil)
  let tm = localtime(&now)
  let bufferSize = 255
  var buffer = [Int8](repeating: 0, count: bufferSize)
  strftime(&buffer, Int(bufferSize), "%Y-%m-%d %H:%M:%S", tm)
  return String(cString: buffer)
}

func randomInt(mod: Int) -> Int {
  #if os(Linux)
    return Int(random() % mod)
  #else
    return Int(arc4random_uniform(mod))
  #endif
}

class ErrorOutputStream: TextOutputStream {
  func write(_ string: String) {
    fputs(string, stderr)
  }
}

class NullOutputStream: TextOutputStream {
  func write(_ string: String) {}
}
