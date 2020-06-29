//
//  Positionable.swift
//  toodim
//
//  Created by Henrik Huttunen on 12.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import Foundation

protocol Positionable {
    var position: Position? { get }
}

struct Position : Equatable, Hashable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }

    var column: Int
    var row: Int
    
    func minus(position: Position) -> Vector {
        return Vector(horizontal: self.column - position.column, vertical: self.row - position.row)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }

    mutating func add(_ v: Vector) {
        self.row += v.vertical
        self.column += v.horizontal
    }    
}

extension Collection where Element : Positionable {
    func elementAt(column: Int, row: Int) -> Element? {
        self.first {
            if let pos = $0.position {
                return pos.column == column && pos.row == row
            } else {
                return false
            }
        }
    }
}
