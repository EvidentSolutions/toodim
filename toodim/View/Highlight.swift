//
//  Highlight.swift
//  toodim
//
//  Created by Henrik Huttunen on 12.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI

struct Highlight : ViewModifier {
    var outside: Bool
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            ZStack {
                Group {
                    if (self.outside) {
                        content
                            .background(
                                Rectangle()
                                    .frame(width: min(size: geo.size), height: min(size: geo.size))
                                    .foregroundColor(.black).opacity(0.3))
                    } else {
                        content
                    }
                    
                }
            }
        }
    }
}

extension View {
    func highlight(_ outside: Bool) -> some View {
        self.modifier(Highlight(outside: outside))
    }
}
