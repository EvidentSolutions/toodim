//
//  PieceVM.swift
//  toodim
//
//  Created by Henrik Huttunen on 25.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import Foundation

struct PieceVM : Identifiable {
    var id: Int {
        piece.id
    }
    var piece: Piece
    var movingAllowed: Bool
    var selectionAllowed: Bool
    
}
