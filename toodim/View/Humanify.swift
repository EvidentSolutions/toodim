//
//  Humanify.swift
//  toodim
//
//  Created by Henrik Huttunen on 11.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI

struct Humanify : ViewModifier {
    var amount: Double = 10
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees((.pi/2) * self.amount * someRandomValue()))
    }
}

private func someRandomValue() -> Double {
    let max = 5.0
    return Double.random(in: 1...max) - (1+max)/2
}

extension View {
    func humanify(amount: Double) -> some View {
        self.modifier(Humanify(amount: amount))
    }
}
