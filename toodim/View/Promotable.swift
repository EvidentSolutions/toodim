//
//  Promotable.swift
//  toodim
//
//  Created by Henrik Huttunen on 13.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI

struct Promotable : ViewModifier {
    var isPromotable: Bool
    var pieceType: PieceType
    var direction: Direction
    var degrees: Double {
        isPromotable ? .pi*6/8 : .pi
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            ZStack {
                content
                Group {
                    if (self.isPromotable) {
                        Circle()
                            .scaleEffect(1.3)
                            .foregroundColor(.promotionLines)
                            .opacity(0.1)
                        Circle()
                            .strokeBorder(Color.promotionLines, lineWidth: 1.5)
                            .scaleEffect(1.3)
                    }
                }
            }
        }
    }
}

extension View {
    func promotable(isPromotable: Bool, pieceType: PieceType, direction: Direction) -> some View {
        self.modifier(Promotable(isPromotable: isPromotable, pieceType: pieceType, direction: direction))
    }
}
