//
//  MoveSequence.swift
//  toodim
//
//  Created by Henrik Huttunen on 22.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import Foundation


/**
 Navigate the board defined by `MoveGenerator`.
 */
struct MoveSequence : Sequence {
    var owner: PlayerType
    var position: Position
    var generator: MoveGenerator
    var piecePositions: [(PlayerType, Position)]
    
    func makeIterator() -> MoveIterator {
        MoveIterator(owner: owner, position: position, generator: generator, piecePositions: piecePositions)
    }
}

struct MoveIterator : IteratorProtocol {
    var owner: PlayerType
    var position: Position
    var generator: MoveGenerator
    var piecePositions: [(PlayerType, Position)]
    
    var continueIteration = true
    
    /**
        Returns positions as long as a piece is found, stops if new position is out of board.
        If a piece is found, the position for piece is returned if it's other player's.
     */
    mutating func next() -> Position? {
        guard (continueIteration) else {
            return nil
        }
        
        switch generator {
        case .Once(let to):
            position.add(to)
            continueIteration = false
        case .Continuous(let direction):
            position.add(direction)
            continueIteration = !piecePositions.hasPiece(at: position)
        }
        
        return piecePositions.getOwner(at: position) != owner &&
            isWithinBoard(position: position) ? position : nil
    }
    
}

private func isWithinBoard(position: Position) -> Bool {
    Game.boardRange.contains(position.row) && Game.boardRange.contains(position.column)
}

extension Collection where Element == (PlayerType, Position) {
    fileprivate func getOwner(at position: Position) -> PlayerType? {
        self.first { $0.1 == position }?.0
    }
    
    fileprivate func hasPiece(at position: Position) -> Bool {
        self.contains { $0.1 == position }
    }
}

