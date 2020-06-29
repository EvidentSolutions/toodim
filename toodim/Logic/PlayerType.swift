//
//  PlayerType.swift
//  toodim
//
//  Created by Henrik Huttunen on 22.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import Foundation

enum PlayerType : CaseIterable {
    case sente, gote
    
    var opponent: PlayerType {
        switch self {
        case .sente:
            return .gote
        case .gote:
            return .sente
        }
    }
}
