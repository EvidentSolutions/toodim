//
//  Color+custom.swift
//  toodim
//
//  Created by Henrik Huttunen on 13.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI

extension Color {
    static var piece: Color { Color("PieceColor") }
    static var piece2: Color { Color("Piece2Color") }
    
    static var pieceSelected: Color { Color.blue }
    
    static var promotionLines: Color { Color.red }
    
    static var promotionDifference: Color { Color.black }
    
    static var promotedCollisionWithOriginal: Color { Color.black }
    
    static var originalObsoleteForPromotion : Color { Color.gray }
    
}

extension UIColor {
    
    static var board: UIColor { UIColor(named: "BoardColor")! }
    static var board2: UIColor { UIColor(named: "BoardColor2")! }
    static var movableLocation = #colorLiteral(red: 1, green: 0.7969581485, blue: 0.4282444119, alpha: 1)
    static var kingInCheck = #colorLiteral(red: 0.5789161921, green: 0.3628943563, blue: 1, alpha: 1)
    static var lastMove = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
}
