
let game = Game()

game.load()

repeat {
    game.render()

    _ = game.update()
}
while !game.isGameOver

game.finish()

