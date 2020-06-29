//
//  Promoted.swift
//  toodim
//
//  Created by Henrik Huttunen on 15.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI

struct Promoted : ViewModifier {
    var isPromoted: Bool
    var pieceType: PieceType
    var direction: Direction
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            ZStack {
                content
                Group {
                    if (self.isPromoted && self.pieceType.showOriginalPieceWhenPromoted) {
                        SelectOriginalPieceView(pieceType: self.pieceType, thin: false)
                            .foregroundColor(Color.promotionDifference)
                            .offset(x: 0, y: -geo.size.height/4)
                            .scaleEffect(0.5)
                            .direction(self.direction)
                    }
                }
            }
        }
    }
}

extension View {
    func promoted(isPromoted: Bool, pieceType: PieceType, direction: Direction) -> some View {
        self.modifier(Promoted(isPromoted: isPromoted, pieceType: pieceType, direction: direction))
    }
}
