//
//  Piece.swift
//  toodim
//
//  Created by Henrik Huttunen on 12.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import Foundation


struct Piece: Equatable, Positionable, Identifiable, Hashable {
    private static var ids = 0

    let type: PieceType
    var owner: PlayerType
    var selected = false
    var isPromoted = false
    var isPromotable = false
    var position: Position?
    let id: Int
    var moveCount: Int = 0
    var lastMoveFrom: Position? = nil
    var lastPieceMoved = false

    init(owner: PlayerType, type: PieceType, row: Int, column: Int) {
        assert((1...Game.boardSize).contains(row))
        assert((1...Game.boardSize).contains(column))
        self.type = type
        self.owner = owner
        self.isPromoted = false
        self.position = Position(column: column, row: row)
        self.id = Piece.ids
        Piece.ids += 1
    }
        
    func getMovesOnBoard(piecePositions: [(PlayerType, Position)]) -> [Position] {
        guard let position = position else { return [] }
        return getMoveGenerators().flatMap { generator in
            MoveSequence(owner: owner, position: position, generator: generator, piecePositions: piecePositions)
        }
    }
    
    private func getMoveGenerators() -> [MoveGenerator] {
        let generators = self.type.getMoveGenerators(promoted: self.isPromoted)
        return self.owner == .sente ? generators : generators.map { vector in vector.mirrorY() }
    }
        
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
