//
//  Board.swift
//  toodim
//
//  Created by Henrik Huttunen on 11.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import Foundation

struct Game {
    static var boardSize = 9
    static var boardRange = 1...boardSize
    static var promotingRows = (boardSize-2)...boardSize
    static var boardPositions = Game.boardRange.flatMap { column in Game.boardRange.map { row in Position(column: column, row: row) } }
    
    var turn = PlayerType.sente
    var pieces = setupDefaultPosition()
    
    var winner: PlayerType? {
        PlayerType.allCases.first {
            player in isPlayerCheckMated(player: player)
        }?.opponent
    }
    
    var piecesOnBoard: [Piece] {
        pieces.filter { $0.position != nil }
    }
    
    var piecePositionsOnBoard: [(PlayerType, Position)] {
        piecesOnBoard.map { ($0.owner, $0.position!) }
    }

    var capturedPieces: [Piece] {
        pieces.filter { $0.position == nil }
    }

    private(set) var selected: Piece? {
        get {
            pieces.first { $0.selected }
        }
        set {
            pieces.chooseElement(keyPath: \.selected, element: newValue)
        }
    }
    
    private(set) var promotable: Piece? {
        get {
            pieces.first { $0.isPromotable }
        }
        set {
            pieces.chooseElement(keyPath: \.isPromotable, element: newValue)
        }
    }
    
    private(set) var lastMove: Piece? {
        get {
            pieces.first { $0.lastPieceMoved }
        }
        set {
            pieces.chooseElement(keyPath: \.lastPieceMoved, element: newValue)
        }
    }
    
    func isPromotionPossible(player: PlayerType) -> Bool {
        piecesOnBoard.contains { $0.owner == player && $0.isPromotable}
    }
    
    var anyAvailableMovesForSelected: Bool? {
        if let selected = selected {
            return getMovablePositionsFor(piece: selected).count > 0
        } else {
            return nil
        }
    }
    
    func isPlayerCheckMated(player: PlayerType) -> Bool {
        let playerMoves = pieces.filter { $0.owner == player }
        return playerMoves.allSatisfy { getMovablePositionsFor(piece: $0).isEmpty }
    }
    
    var movablePositions: [Position] {
        guard let selected = selected, selected.owner == turn else { return [] }
        
        return getMovablePositionsFor(piece: selected)
    }
    
    func getMovablePositionsFor(piece: Piece) -> [Position] {
        return getPotentialMovablePositionsFor(piece: piece).filter { move in
            Game.isValidMove(player: piece.owner, piece: piece, move: move, game: self)
        }
    }
    
    private func getPotentialMovablePositionsFor(piece: Piece) -> [Position] {
        if piece.position != nil {
            // Move a piece within the board
            return piece.getMovesOnBoard(piecePositions: piecePositionsOnBoard)
        } else {
            // Dropping a captured piece to the board
            
            return Game.boardPositions
                .filter { position in
                    getPiece(at: position) == nil &&
                    !piece.type.withinAutomaticPromotionDistance(distance: distanceToOppositeEnd(owner: piece.owner, row: position.row))
                }
                .filter { position in
                    if (piece.type != .Pawn) {
                        return true
                    }                    
                    if self.hasUnpromotedPawnAt(owner: piece.owner, column: position.column) {
                        return false
                    }
                    // TODO if this is called recursively, don't do this check?
                    if Game.moveCausesCheckmate(player: piece.owner, piece: piece, move: position, game: self) {
                        return false
                    }
                    
                    return true
                }
            }
        }

    static func testMove(player: PlayerType, piece: Piece, move: Position, game: Game, test: (Game) -> Bool) -> Bool {
        var gameCopy = game
        // movablePositionsKnownToContain prevents infinite recursion
        let doesMakeAMove = gameCopy.moveSelectedPiece(piece: piece, to: move, movablePositionsKnownToContain: true)
        return doesMakeAMove ? test(gameCopy) : false
    }

    static func moveCausesCheckmate(player: PlayerType, piece: Piece, move: Position, game: Game) -> Bool {
        testMove(player: player, piece: piece, move: move, game: game) { game in
            game.isPlayerCheckMated(player: player.opponent)
        }
    }

    static func isValidMove(player: PlayerType, piece: Piece, move: Position, game: Game) -> Bool {
        testMove(player: player, piece: piece, move: move, game: game) { game in
            !game.checkedKingPosition(of: player)
        }
    }
    
    func hasUnpromotedPawnAt(owner: PlayerType, column: Int) -> Bool {
        self.pieces.contains { $0.owner == owner && $0.position?.column == column && $0.type == .Pawn && !$0.isPromoted }
    }
    
    mutating func selectPiece(_ piece: Piece) {
        guard piece.owner == turn else { return }
        if let selected = selected {
            if (selected.owner == piece.owner) {
                self.selected = piece
            }
        } else {
            self.selected = piece
        }
                
    }
    
    mutating func moveSelectedPiece(piece: Piece, to position: Position, movablePositionsKnownToContain: Bool = false) -> Bool {
        //guard piece.owner == turn else { return false }
        
        if !movablePositionsKnownToContain && !movablePositions.contains(position) {
            return false
        }

        if let captured = getPiece(at: position) {
            guard (captured.owner != piece.owner && captured.type.isCapturable) else {
                return false
            }

            pieces.update(matching: captured) {
                $0.position = nil
                $0.owner = piece.owner
                $0.isPromoted = false
            }
        }        

        if piece.type.withinAutomaticPromotionDistance(distance: distanceToOppositeEnd(owner: piece.owner, row: position.row)) {
            promote(piece, automatic: true)
        } else if piece.type.isPromotable, let pos = piece.position, crossesPromotionBoundary(old: pos, new: position, owner: piece.owner) {
            promotable = selected
        } else {
            promotable = nil
        }
                
        pieces.update(matching: piece) {
            $0.lastMoveFrom = $0.position
            $0.position = position
            $0.moveCount += 1
        }
        
        self.lastMove = piece
        self.selected = nil
        
        turn = turn.opponent
        
        return true
    }
    
    mutating func promote(_ piece: Piece, automatic: Bool = false) {
        pieces.update(matching: piece) {
            // Checks isPromotable from source array, not from the argument--i.e. piece--whose values might already be obsolete
            guard ($0.isPromotable || automatic) else { return }

            $0.isPromoted = true
        }
    }
    
    func getPiece(id: Int) -> Piece {
        pieces.first { $0.id == id }!
    }
    
    func getPieceAt(column: Int, row: Int) -> Piece? {
        self.pieces.elementAt(column: column, row: row)
    }
    
    func getPiece(at position: Position) -> Piece? {
        self.getPieceAt(column: position.column, row: position.row)
    }
    
    mutating func clearPieceSelection() {
        self.selected = nil
    }
        
    func getKingPosition(player: PlayerType) -> Position {
        piecesOnBoard.first { $0.type == .King && $0.owner == player }!.position!
    }
    
    /** Find checks to owner's king  */
    func checkedKingPosition(of owner: PlayerType) -> Bool {
        let kingPosition = getKingPosition(player: owner)
        
        let piecePositions = piecePositionsOnBoard
        for piece in piecesOnBoard.filter({ $0.owner == owner.opponent }) {
            if piece.getMovesOnBoard(piecePositions: piecePositions).contains(kingPosition) {
                return true
            }
        }
        return false
    }
    
    func hasKingInCheck(at position: Position) -> Bool {
        PlayerType.allCases.contains { player in
           // getKingPosition is only optimization
           position == getKingPosition(player: player) && checkedKingPosition(of: player)
        }
    }
}

private func crossesPromotionBoundary(old: Position, new: Position, owner: PlayerType) -> Bool {
    // TODO slightly hackish
    let oldRow = owner == .sente ? old.row : Game.boardSize - old.row + 1
    let newRow = owner == .sente ? new.row : Game.boardSize - new.row + 1
    
    return Game.promotingRows.contains(oldRow) || Game.promotingRows.contains(newRow)
}

private func setupDefaultPosition() -> [Piece] {
    [
        row(.Lance, .Knight, .Silver, .Gold, .King, .Gold, .Silver, .Knight, .Lance),
        row(nil, .Rook, nil, nil, nil, nil, nil, .Bishop, nil),
        row(.Pawn, .Pawn, .Pawn, .Pawn, .Pawn, .Pawn, .Pawn, .Pawn, .Pawn)
    ]
        .enumerated().flatMap { (index, row) in
            row.pieces(for: .sente, row: index + 1) +
            row.reversed().pieces(for: .gote, row: Game.boardSize - index)
        }
}

private func row(_ types: PieceType?...) -> [PieceType?] { types }

extension Collection where Element == PieceType? {
    fileprivate func pieces(for player: PlayerType, row: Int) -> [Piece] {
        self.enumerated().compactMap { index, type in type.map { Piece(owner: player, type: $0, row: row, column: index + 1) } }
    }
}


private func distanceToOppositeEnd(owner: PlayerType, row: Int) -> Int {
    let end = owner == .gote ? 1 : Game.boardSize
    return abs(row - end)
}

