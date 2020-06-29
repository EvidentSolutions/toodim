//
//  Arrow.swift
//  toodim
//
//  Created by Henrik Huttunen on 11.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI

func makeArrows(arrows: Int, addHead: Bool = false, thin: Bool = false) -> some View {
    let value = .pi*2 / CGFloat(arrows)
    return ZStack {
        ForEach(1..<arrows+1) { i in
            Arrow(addHead: addHead, thin: thin)
                .transformEffect(CGAffineTransform.identity.rotated(by: CGFloat(i) * value))
        }
    }
}

struct Arrow : Shape {
    var addHead = false
    var thin = false
    
    func path(in rect: CGRect) -> Path {
        let radius = rect.height / 2.2 // amount of space from origin to one direction. should be better name
        let height = radius * (2 / 3)
        let head = (radius - height) * 3/5
        let thickness = CGFloat(thin ? 0.5 : 1) // Actually means half the thickness
        
        return Path() { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: -thickness, y: 0))
            path.addLine(to: CGPoint(x: -thickness, y: height))
            if addHead {
                path.addLine(to: CGPoint(x: -head, y: height))
                path.addLine(to: CGPoint(x: 0, y: height + head))
                path.addLine(to: CGPoint(x: head, y: height))
            }
            path.addLine(to: CGPoint(x: thickness, y: height))
            path.addLine(to: CGPoint(x: thickness, y: 0))
            path.closeSubpath()
        }
    }
}
