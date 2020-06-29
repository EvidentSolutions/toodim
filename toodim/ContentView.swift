//
//  ContentView.swift
//  toodim
//
//  Created by Henrik Huttunen on 10.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        VStack {
            King()
                .foregroundColor(.red)
            Pawn()
//            Bishop()
//                .fill(Color.blue)
//            Rook()
//                .fill(Color.black)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
