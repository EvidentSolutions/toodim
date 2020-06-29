//
//  Vector.swift
//  toodim
//
//  Created by Henrik Huttunen on 24.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import Foundation

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
