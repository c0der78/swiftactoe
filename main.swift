import Darwin;

func resetCursor() {
    print("\u{1B}[9A\u{1B}[J", appendNewline:false);
}

var b = Board();

var game = Game(board: b);

repeat {
    print("Do you want to be X or O (X goes first)? ", appendNewline: false);
} 
while(!game.setHumanPlayerFromInput())

game.displayBoard();

repeat {

    if (!game.placeHumanMoveFromInput()) {
        // try again, get new input
        continue;
    }

    if (!game.placeComputerMove()) {
        // system error
        break;
    }

    resetCursor();

    game.displayBoard();

}
while(!game.isGameOver)

resetCursor();

game.displayBoard();

game.displayWinner();

