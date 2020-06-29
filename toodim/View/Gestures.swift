//
//  Gestures.swift
//  toodim
//
//  Created by Henrik Huttunen on 12.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI

func selectPieceGesture(_ piece: Piece, _ game: GameVM) -> some Gesture {
    TapGesture(count: 1)
    .onEnded {
        game.selectPiece(piece)
    }
}

func moveSelectedPieceGesture(_ position: Position?, _ game: GameVM) -> some Gesture {
    TapGesture(count: 1)
    .onEnded {
        game.moveSelectedPiece(to: position)
    }
}

func promotePieceGesture(_ piece: Piece, _ game: GameVM) -> some Gesture {
    TapGesture(count: 2)
    .onEnded {
        game.promotePiece(piece)
    }
}
