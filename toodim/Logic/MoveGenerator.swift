//
//  MoveGenerator.swift
//  toodim
//
//  Created by Henrik Huttunen on 19.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import Foundation

enum MoveGenerator {
    case Once(to: Vector)
    case Continuous(direction: Vector)
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
