//
//  PlayerVM.swift
//  toodim
//
//  Created by Henrik Huttunen on 23.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import Foundation

struct PlayerVM {
    var player: PlayerType
    var winner: PlayerType?
    var isTurn: Bool
    var isPromotionPossible: Bool
    var anyAvailableMovesForSelected: Bool?
    
    var info: String {
        winner == player ?
            "You won the game 🎉" :
            winner?.opponent == player ? "You lost the game." :
            isTurn ? (
                anyAvailableMovesForSelected.map { $0 ?
                    "Tap highlighted square to move the piece." :
                    "No available moves. Select another piece."
                } ?? "Select a piece to move."
            ) :
            isPromotionPossible ? "Promote by double tap, or wait for opponent's move" :
        "Wait for your turn"
    }
        
}
