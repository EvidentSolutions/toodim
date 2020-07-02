//
//  ViewModels.swift
//  toodim
//
//  Created by Henrik Huttunen on 12.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI

class GameVM : ObservableObject {
    
    private var undoStack: [Game] = []
    
    @Published private(set) var game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    var player1: PlayerVM {
        createPlayer(player: .sente)
    }
    var player2: PlayerVM {
        createPlayer(player: .gote)
    }
    
    var squares: [SquareVM] {
        let movablePositions = game.movablePositions
        return Game.boardPositions.map { position in
            let piece = game.getPiece(at: position)
            let movable = movablePositions.contains(position)
            return SquareVM(
                position: position,
                piece: piece,
                hasKingInCheck: game.hasKingInCheck(at: position),
                hasMovablePosition: movable)
        }
    }
    
    func createPlayer(player: PlayerType) -> PlayerVM {
        PlayerVM(player: player, winner: game.winner, isTurn: game.turn == player, isPromotionPossible: game.isPromotionPossible(player: player), anyAvailableMovesForSelected: game.anyAvailableMovesForSelected)
    }
    
    func selectPiece(_ piece: Piece) {
        self.game.selectPiece(piece)
    }
    
    func moveSelectedPiece(to position: Position?) {
        guard let position = position else { return } // nil should be denied in parameter type
        let copy = game
        if let selected = game.selected, self.game.moveSelectedPiece(piece: selected, to: position) {
            addGameToUndo(game: copy)
        }
    }
    
    func getPieceAt(column: Int, row: Int) -> Piece? {
        self.game.getPieceAt(column: column, row: row)
    }
    
    var capturedPiecesSente: [PieceVM] {
        self.getCapturedPieces(owner: .sente).map { createPieceVM(piece: $0) }
    }
    
    var capturedPiecesGote: [PieceVM] {
        self.getCapturedPieces(owner: .gote).map { createPieceVM(piece: $0) }
    }
    
    var piecesOnBoard: [PieceVM] {
        self.game.piecesOnBoard.map { createPieceVM(piece: $0) }
    }
    
    func createPieceVM(piece: Piece) -> PieceVM {
        PieceVM(piece: piece, movingAllowed: movingAllowed(piece: piece), selectionAllowed: selectionAllowed(piece: piece))
    }
    
    func movingAllowed(piece: Piece) -> Bool {
        if let position = piece.position, let selected = self.selectedPiece, position != selected.position {
            return true
        } else {
            return false
        }
    }
    
    func selectionAllowed(piece: Piece) -> Bool {
        self.selectedPiece == nil || piece.owner == self.selectedPiece?.owner
    }
    
    var selectedPiece: Piece? {
        self.game.selected
    }
    
    var turn: PlayerType {
        self.game.turn
    }
    
    func getCapturedPieces(owner: PlayerType) -> [Piece] {
        self.game.capturedPieces.filter { $0.owner == owner }
    }
    
    func promotePiece(_ piece: Piece) {
        self.game.promote(piece)
        // Hack because gestures are overlapping and by promoting with double tapping, user also selects promotion
        self.game.clearPieceSelection()
    }
    
    func undo() {
        if let previous = self.undoStack.popLast() {
            self.game = previous
        }
    }
    
    func addGameToUndo(game: Game) {
        var copy = game
        copy.clearPieceSelection()
        self.undoStack.append(copy)
    }
    
    func startNewGame() {
        addGameToUndo(game: game)
        self.game = Game()
    }
}
