# toodim - couch shogi

Play a shogi game on the couch with a friend using an iOS device.

![Shogi app](app.png?raw=true "Shogi app")


Traditional kanji markings on the game pieces are replaced with figures that indicate not only identify the piece, but also shows directions to give a clue what moves are potentially available.
The visuals hopefully help western players to grok the game mechanics faster than with traditional pieces.
The design was inspired by Douglas Crockford's shogi page.

The app enforces all shogi rules except a couple of game ending rules (repetition, impasse, illegal move, resignation). 
Please let me know if rules do not work as expected.

# How to play

Select a piece by tapping on it. Squares become highlighted to indicate where you can move the selected piece. 
Tap on one of the highlighted square and the selected piece will move there. After that it is your opponent's turn.
If no square becomes highlighted, that piece does not have any legal moves. Select some other piece.

### Win by getting opponent's king in checkmate:
- Check more or less means that your piece could move to the square where your opponent's king is.    
- If player's king is in check, opponent must make a move so that there is no check to their king. 
- If they cannot get rid of all of the checks, it's a checkmate, and you win.

### Capturing and using captured pieces:
- If you move your piece to a square that has opponent's piece, that piece is captured as an unpromoted piece.
- Starting from your next turn, you may choose any captured piece, and drop it to the board. 
- A pawn cannot be dropped to a square if the column where that square is has already an unpromoted pawn of yours in it. 
- Other  piece specific rules about dropping are omitted here but not in the app. 

### Promotion:
- Promotion means to change your piece's moving capabilities. Once promoted it cannot be undone until captured.
- Promotion can happen only at the side nearest to your opponent. Making a move in the three last rows of board activates promotion (but not dropping). 
- If you move your piece so that it actives promotion, the piece visually shows it. Double tap to promote before your opponent makes their move.
- You don't need to promote if you choose so. If you choose so, you can promote later if you first make a move in the promotion area.
- Automatic promotion is made when the piece wouldn't even theoretically have any legal moves.


## Implementation

### The code structure as folders

Logic
- gameplay logic

ViewModel
- intermediate representation of Game pieces, gives rendering data model to be used straightforwardly

View 
- rendering of board, pieces and user interactions

### Details

- Struct `Game` is the full model of game state, with an array of `Piece`s as the main information. `Piece` knows its position, and what type of shogi piece it is, etc.
- Due to `struct` semantics, it's easy to copy state for undo, or to make a move for checking for required invariants to hold, e.g. Pawn drop may not checkmate. The flip side is that modifications are not made directly to a piece but instead the array is updated at the index containing the piece.
- `MoveGenerator` is the building block to define what moves piece has. It is either a `Once` that directly moves to particular place relative to a piece, or it is a `Multiple` which yields multiple positions to a direction. The actual generative logic implemented in `MoveIterator`.
- `GameViewModel` conforms to protocol `ObservableObject` so that Views know to re-render when its content changes.
- The board is made by first laying out the board squares. In a separate step, the pieces are put on top of the squares.
- Piece consists of wooden shape and piece specific figure. The figure is a composition of lines that can have arrow-head for representing multiple different positions in that direction.
- Some visual enhancements are defined as Modifiers, e.g. `Highlight`  
- Some of the promoted pieces show a scaled down version of the original movement figure on the corner of the piece,  see `Promoted` modifier
- Player interactions are defined through gestures. The definition is a little bit problematic as some activate simultaneously.

## TODO

See [TODO.md](TODO.md)
