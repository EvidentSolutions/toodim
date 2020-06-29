//
//  LastMoveView.swift
//  toodim
//
//  Created by Henrik Huttunen on 28.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI


// TODO the implementation is a bit off regarding position

/**
 Draws either an arrow from previous position to new position, or circle if previous position was captured piece board.
*/
struct LastMoveView : View {
    var move: Piece?
    var containerSize: CGSize
    
    var body : some View {
        Group {
            if (self.move?.position != nil && self.move?.lastMoveFrom != nil) {
                SharpeningArrow(length: distance, itemSize: itemSize)
                    .fill(Color(UIColor.lastMove))
                    .transformEffect(CGAffineTransform.identity.rotated(by: CGFloat(atan2(deltaY, deltaX) - .pi/2)))
                    .transformEffect(
                        CGAffineTransform(translationX: fromOffset.x, y: fromOffset.y)
                    )

            } else if self.move?.position != nil {
                // Instead of this, we might want to show arc to the captured pieces board
                
                Circle()
                    .size(CGSize(width: itemSize/4, height: itemSize/4))
                    .fill(Color(UIColor.lastMove))
                    .transformEffect(
                        CGAffineTransform(translationX: getPosition(position: move!.position!).x - itemSize/8,
                                          y: getPosition(position: move!.position!).y - itemSize/8)
                    )
            }
        }
            .opacity(0.3)
    }
    
    var itemSize: CGFloat {
        getItemSize(containerSize: containerSize)
    }
    
    var deltaX: Double {
        if let a = move?.position, let b = move?.lastMoveFrom {
            return Double(a.column - b.column)
        } else {
            return 0
        }
    }
    
    var deltaY: Double {
        if let a = move?.position, let b = move?.lastMoveFrom {
            return Double(a.row - b.row)
        } else {
            return 0
        }
    }
    
    var distance: Double {
        sqrt(pow(deltaX, 2) + pow(deltaY, 2))
    }
    
    var angle: Double {
        sqrt(pow(deltaX, 2) + pow(deltaY, 2))
    }
    
    var fromOffset: CGPoint {
        getPosition(position: move!.lastMoveFrom!)
    }
    
    var toOffset: CGPoint {
        getPosition(position: move!.position!)
    }

    func getPosition(position: Position) -> CGPoint{
        let o = getOffset(for: position, containerSize: containerSize)
        let i = itemSize
        return CGPoint(x: o.width + i/2, y: o.height + i/2)
    }
    
    
}

struct SharpeningArrow : Shape {
    var length: Double
    var itemSize: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let maxWidth = CGFloat(5)
        
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: -maxWidth, y: CGFloat(length) * itemSize - itemSize/4))
            path.addLine(to: CGPoint(x: 0, y: CGFloat(length) * itemSize))
            path.addLine(to: CGPoint(x: maxWidth, y: CGFloat(length) * itemSize  - itemSize/4))
            path.closeSubpath()
        }

    }
}
