//
//  SquareVM.swift
//  toodim
//
//  Created by Henrik Huttunen on 23.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import Foundation

struct SquareVM : Identifiable, Equatable {
    var id: Position {
        position
    }
    
    var position: Position
    var piece: Piece?
    var hasKingInCheck: Bool
    var hasMovablePosition: Bool
    
    static func == (lhs: SquareVM, rhs: SquareVM) -> Bool {
        lhs.id == rhs.id
    }
}

