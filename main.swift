import Darwin;

func resetCursor() {
    print("\u{1B}[9A\u{1B}[J", appendNewline:false);
}

var b = Board();

print("Select starting player:\n\n\u{1B}[1;32m1.\u{1B}[0m Computer \u{1B}[32m2.\u{1B}[0m User: ", appendNewline: false);

var choice = readInt();

if(choice == 1){
    var p = Point(x: Int(arc4random_uniform(3)), y: Int(arc4random_uniform(3)));
    b.placeAMove(p, player: 1);
}

b.displayBoard();

while (!b.isGameOver) {

    if (!b.takeHumanInput()) {
        continue;
    }

    if (b.isGameOver) { break; }
    
    b.minimax(0, turn: 1);  
    
    if (b.computersMove != nil) {
        if (!b.placeAMove(b.computersMove!, player: 1)) {
            continue;
        }
    }

    resetCursor();

    b.displayBoard();
}

resetCursor();

b.displayBoard();

if (b.hasXWon) { 
    print("Unfortunately, you lost!");
} else if (b.hasOWon) { 
    print("You win!"); //Can't happen
} else {
    print("It's a draw!");
}

