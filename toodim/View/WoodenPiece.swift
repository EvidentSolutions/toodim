//
//  WoodenPiece.swift
//  toodim
//
//  Created by Henrik Huttunen on 11.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI


struct Piecefy: ViewModifier {
    
    var pieceSize: CGFloat
    var selected: Bool = false
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack {
                WoodPiece(color: self.selected ? Color.piece : Color.piece, lineWidth: self.selected ? 2 : 1.5)
                    .frame(width: min(size: geometry.size), height: min(size: geometry.size))                
                // TODO content should start from zero and fill to positive rectangle size, not centered origin (0, 0)
                // we can then remove this transform
                content.transformEffect(.init(translationX: geometry.size.width/2, y: geometry.size.height/2))
            }
        }
            .padding(3)
    }
}

struct WoodPiece : View {
    
    var color: Color
    var lineWidth: CGFloat
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.piece, Color.piece2]),
            startPoint: .leading,
            endPoint: .trailing
        ).mask(
            WoodenShape()
            .foregroundColor(.yellow)
        )
            .overlay(
                WoodenShape()
                    .stroke(self.color, lineWidth: lineWidth)
        )


    }
}

struct WoodenShape : Shape {
    func path(in rect: CGRect) -> Path {
        let h = rect.height
        let w = rect.width / 2
        let upperW = w * 4/5
        let bodyHeight = h * (4/5)
        let head = h - bodyHeight
        let wEdge = w/8

        return Path() { path in
            path.move(to: CGPoint(x: wEdge, y: 0))
            path.addLine(to: CGPoint(x: wEdge+w-upperW, y: bodyHeight))
            
            // HEAD
            path.addLine(to: CGPoint(x: w, y: bodyHeight + head))
            
            path.addLine(to: CGPoint(x: -wEdge+w+upperW, y: bodyHeight))
            path.addLine(to: CGPoint(x: 2*w-wEdge, y: 0))
            path.closeSubpath()
        }
    }
    
}

extension View {
    func piecefy(pieceSize: CGFloat, selected: Bool) -> some View {
        self.modifier(Piecefy(pieceSize: pieceSize, selected: selected))
    }
}
