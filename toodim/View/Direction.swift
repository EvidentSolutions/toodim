//
//  Direction.swift
//  toodim
//
//  Created by Henrik Huttunen on 15.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI

extension View {
    
    func direction(_ direction: Direction = .default) -> some View {
        self.modifier(ChangeDirection(direction: direction))
    }
}

struct ChangeDirection: ViewModifier {
    
    var direction: Direction
    
    func body(content: Content) -> some View {
        Group {
            if (direction == .opposite) {
                content.rotationEffect(.radians(.pi))
            } else {
                content
            }
        }
    }
}

enum Direction {
    case `default`, opposite
}
