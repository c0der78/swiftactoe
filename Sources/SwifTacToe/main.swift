let cmd = SwifTacToe()

do {
  try cmd.execute()
} catch {
  print(error, to: &errorStream)
  osexit(1)
}
