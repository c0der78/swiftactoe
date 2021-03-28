#if os(Linux)
	import Glibc
#else
	import Darwin
#endif


func randomLoc() -> Int {
#if os(Linux)
  return Int(random() % 3)
#else
  return Int(arc4random_uniform(3))
#endif
}

