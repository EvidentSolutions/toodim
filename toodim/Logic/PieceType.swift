//
//  PieceType.swift
//  toodim
//
//  Created by Henrik Huttunen on 22.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import Foundation

enum PieceType {
    case King
    case Gold
    case Silver
    case Pawn
    case Knight
    case Lance
    case Rook
    case Bishop

    var isPromotable: Bool {
        self != .King
    }
    
    var isCapturable: Bool {
        self != .King
    }
    
    var showOriginalPieceWhenPromoted: Bool {
        switch self {
        case .Silver, .Pawn, .Knight, .Lance:
            return true
        default:
            return false
        }
    }
    
    func withinAutomaticPromotionDistance(distance: Int) -> Bool {
        // TODO this could be done without explicitly checking piece type by using move generators
        switch self {
        case .Pawn, .Lance:
            return distance <= 0
        case .Knight:
            return distance <= 1
        case .King, .Gold, .Silver, .Rook, .Bishop:
            return false
        }
    }

    func getMoveGenerators(promoted: Bool) -> [MoveGenerator] {
        let UP = Vector(horizontal: 0, vertical: 1)
        
        if (promoted) {
            switch self {
            case .King:
                return getMoveGenerators(promoted: false)
            case .Gold, .Silver, .Pawn, .Knight, .Lance:
                return PieceType.Gold.getMoveGenerators(promoted: false)
            case .Rook:
                return PieceType.Rook.getMoveGenerators(promoted: false) + diagonals().map { .Once(to: $0) }
            case .Bishop:
                return PieceType.Bishop.getMoveGenerators(promoted: false) + orthogonals().map { .Once(to: $0) }
            }
        } else {
            switch self {
            case .King:
                return (orthogonals() + diagonals()).map { .Once(to: $0 ) }
            case .Gold:
                return (([
                    Vector(horizontal: 1, vertical: 1),
                    Vector(horizontal: -1, vertical: 1)
                ]) + orthogonals()).map { .Once(to: $0 ) }
            case .Silver:
                return ([UP] + diagonals()).map { .Once(to: $0) }
            case .Pawn:
                return [.Once(to: UP)]
            case .Knight:
                return [
                    Vector(horizontal: 1, vertical: 2),
                    Vector(horizontal: -1, vertical: 2)
                ].map { .Once(to: $0) }
            case .Lance:
                return [.Continuous(direction: UP)]
            case .Rook:
                return orthogonals().map { .Continuous(direction: $0 ) }
            case .Bishop:
                return diagonals().map { .Continuous(direction: $0 ) }
            }
        }
    }
    
}

private func diagonals() -> [Vector] {
    return [
        Vector(horizontal: 1, vertical: 1),
        Vector(horizontal: 1, vertical: -1),
        Vector(horizontal: -1, vertical: 1),
        Vector(horizontal: -1, vertical: -1)
    ]
}

private func orthogonals() -> [Vector] {
    return [
        Vector(horizontal: 0, vertical: 1),
        Vector(horizontal: 0, vertical: -1),
        Vector(horizontal: -1, vertical: 0),
        Vector(horizontal: 1, vertical: 0)
    ]
}
