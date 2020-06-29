//
//  MovingPointer.swift
//  toodim
//
//  Created by Henrik Huttunen on 19.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import Foundation

enum MoveGenerator {
    case Once(to: Vector)
    case Continuous(direction: Vector)
    
    func canMove(vector: Vector) -> Bool {
        switch self {
        case .Once(let to):
            return vector == to
        case .Continuous(let direction):
            guard let horizontalMultiple = multiple(target: vector.horizontal, direction: direction.horizontal) else { return false }
            guard let verticalMultiple = multiple(target: vector.vertical, direction: direction.vertical) else { return false }
            return horizontalMultiple == 0 || verticalMultiple == 0 || horizontalMultiple == verticalMultiple
        }
    }
    
    private func multiple(target a: Int, direction b: Int) -> Int? {
        if (a == 0 && b == 0) { return 0 }
        if (a == b) { return 1 }
        if (b == 0) { return nil }
        if (!sameSign(a, b)) { return nil }
        if (abs(a) < abs(b)) { return nil }
        return (abs(a) % abs(b) == 0) ? abs(a) / abs(b) : nil
    }
}

private func sameSign(_ a: Int, _ b: Int) -> Bool {
    return (a >= 0) == (b >= 0)
}

struct Vector : Equatable {
    var horizontal: Int
    var vertical: Int
    
    mutating func mirrorX() {
        self.horizontal = -horizontal
    }
    
    mutating func mirrorY() {
        self.vertical = -vertical
    }
    
    static func == (lhs: Vector, rhs: Vector) -> Bool {
        lhs.horizontal == rhs.horizontal && lhs.vertical == rhs.vertical
    }
}

extension MoveGenerator {
    func mirrorY() -> MoveGenerator {
        switch self {
        case .Once(let to):
            var newTo = to
            newTo.mirrorY()
            return .Once(to: newTo)
            
        case .Continuous(let direction):
            var newDirection = direction
            newDirection.mirrorY()
            return .Continuous(direction: newDirection)
        }
    }
}
