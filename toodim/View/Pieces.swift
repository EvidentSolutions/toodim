//
//  Pieces.swift
//  toodim
//
//  Created by Henrik Huttunen on 11.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI

struct Pieces {
    
    struct Pawn : View {
        var thin = false
        var body: some View {
            Arrow(addHead: false, thin: thin)
        }
    }
    
    struct PromotedPawn : View {
        
        var body: some View {
            PromotedToGold()
        }
    }
    
    struct Lance: View {
        var thin = false
        var body: some View {
            Arrow(addHead: true, thin: thin)
        }
    }
    
    struct PromotedLance: View {
        var body: some View {
            PromotedToGold()
        }
    }
    
    
    struct King : View {
        var body: some View {
            makeArrows(arrows: 8)
        }
    }
    
    struct Bishop: View {
        var thin = false
        var body: some View {
            makeArrows(arrows: 4, addHead: true, thin: thin)
                .transformEffect(CGAffineTransform.identity.rotated(by: .pi/4))
        }
    }
    
    struct DragonHorse : View { // Promoted Bishop
        
        var body : some View {
            ZStack {
                makeArrows(arrows: 4)
                makeArrows(arrows: 4, addHead: true)
                    .transformEffect(CGAffineTransform.identity.rotated(by: .pi/4))
            }
                .foregroundColor(Color.promotionLines)

        }
    }
    
    struct Rook : View {
        var thin = false
        var body : some View {
            makeArrows(arrows: 4, addHead: true, thin: thin)
        }
    }
    
    struct DragonKing : View { // Promoted Rook
        
        var body : some View {
            ZStack {
                makeArrows(arrows: 4, addHead: true)
                makeArrows(arrows: 4)
                    .transformEffect(CGAffineTransform.identity.rotated(by: .pi/4))
            }
                .foregroundColor(Color.promotionLines)
        }
    }
    
    struct Gold : View {
        
        var body : some View {
            ZStack {
                makeArrows(arrows: 4)
                Arrow()
                    .transformEffect(CGAffineTransform.identity.rotated(by: .pi/4))
                Arrow()
                    .transformEffect(CGAffineTransform.identity.rotated(by: -.pi/4))
            }
        }
    }
    
    struct PromotedToGold : View {
        
        var body : some View {
            ZStack {
                makeArrows(arrows: 4)
                Arrow()
                    .transformEffect(CGAffineTransform.identity.rotated(by: .pi/4))
                Arrow()
                    .transformEffect(CGAffineTransform.identity.rotated(by: -.pi/4))
            }
                .foregroundColor(Color.promotionLines)
        }
    }
    
    struct Silver : View {
        var thin = false
        var body : some View {
            ZStack {
                Arrow(thin: thin)
                makeArrows(arrows: 4, thin: thin)
                    .transformEffect(CGAffineTransform.identity.rotated(by: .pi/4))
            }
        }
    }
    
    struct PromotedSilver : View {
        var body : some View {
            ZStack {
                PromotedToGold()
            }
        }
    }
    
    struct Knight : View {
        var thin = false
        var body : some View {
            
            ZStack {
                Arrow(thin: thin)
                    .transformEffect(CGAffineTransform.identity.rotated(by: .pi/8))
                Arrow(thin: thin)
                    .transformEffect(CGAffineTransform.identity.rotated(by: -.pi/8))
            }
        }
    }
    
    struct PromotedKnight : View {
        var body : some View {
            PromotedToGold()
        }
    }
}

