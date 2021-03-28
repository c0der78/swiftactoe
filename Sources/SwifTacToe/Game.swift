#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

class Game
{
    private var io: IO
    private var board: Board
    private var player: Player
    private var opposingPlayer: Player?

    var currentPlayer: Player?

    init() {
      self.board = Board()
      self.io = ConsoleIO()
      self.player = Player(input: self.io, output: self.io)
    }

    var isGameOver: Bool {
        //Game is over is someone has won, or board is full (draw)
        return (board.hasWon(Player.X) || board.hasWon(Player.O) || board.availableMoves().count == 0)
    }

    func load() {
     
      repeat {
        self.io.promptNetwork()
        if self.io.readYesNo() != true {
          break
        }

        guard let client = self.io.readNetworkType() else {
          continue
        }

        if client {
          self.io.promptNetworkAddress()
          
          if self.connectToNetwork() {
            break
          }
        } else {
          _ = self.listenForConnections()
          break
        }
          
      } while self.opposingPlayer == nil

      // no opposing player yet if single player
      if self.opposingPlayer == nil {
        repeat {
          self.io.promptTile()
        }
        while !self.readPlayerTile()
        self.opposingPlayer = Bot(self.board, 
                                  tile: self.player == Player.X ? Player.O : Player.X)
      }
     
      self.currentPlayer = self.player.isFirst ? self.player : self.opposingPlayer
    }

    func update() -> Bool {

      let val = self.placeMove()

      if self.currentPlayer == self.player {
        self.currentPlayer = self.opposingPlayer 
      } else {
        self.currentPlayer = self.player 
      }

      return val
    }

    //! reads input and determines human player (X or O)
    private func readPlayerTile() -> Bool {

        guard let choice = self.io.readTile() else {
          return false
        }

        self.player.tile = choice

        return true
    }

    private func connectToNetwork() -> Bool {

      guard let addr = self.io.readNetworkAddress() else {
        return false 
      }

      var client: Client
      var success = false

      do {
        client = try Client() 
        success = client.connect(addr: addr)
      } catch { return false }

      if success {
        self.opposingPlayer = Player(input: client, output: nil)
      }

      return success 
    }

    private func listenForConnections() -> Bool {
      return false
    }

    private func placeMove() -> Bool {

      guard let player = self.currentPlayer else { return false }

      guard let point = player.input?.readMove() else {
        return false 
      }

      return self.board.placeMove(point: point, player: player.tile)
    }

    func render() {
      self.io.draw(board: self.board)

      self.currentPlayer?.output?.promptMove()
    }

    func finish() {
       self.io.draw(board: self.board)

       if board.hasWon(self.player.tile) {
         self.io.draw(finish: true)
       } else if let tile = self.opposingPlayer?.tile, board.hasWon(tile) {
         self.io.draw(finish: false)
       } else {
         self.io.draw(finish: nil)
       }
    }
}
