//
//  PieceView.swift
//  toodim
//
//  Created by Henrik Huttunen on 13.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI

struct PieceView : View {
    var piece: Piece
    
    var body : some View {
        GeometryReader { geometry in
            Group {
                SelectPieceView(isPromoted: self.piece.isPromoted, pieceType: self.piece.type)
                    .piecefy(pieceSize: min(size: geometry.size), selected: self.piece.selected)
                    .humanify(amount: self.piece.moveCount > 0 ? 2.0 : 0)
                    .direction(self.piece.owner == .gote ? .opposite : .default)
                    .promotable(
                        isPromotable: self.piece.isPromotable && !self.piece.isPromoted,
                        pieceType: self.piece.type,
                        direction: self.piece.direction)
                    .promoted(isPromoted: self.piece.isPromoted, pieceType: self.piece.type, direction: self.piece.direction)
                    .scaleEffect(self.piece.type.scale)
                    .scaleEffect(self.piece.selected ? 1.2 : 1)
                    .highlight(self.piece.selected)
                    .transition(.slide)
                    .animation(.linear(duration: 0.4))
            }
                .foregroundColor(Color.black)
        }
    }
    
}

struct SelectPieceView : View {
    var isPromoted: Bool
    var pieceType: PieceType
    
    var body: some View {
        Group {
            if (isPromoted) {
                SelectPromotedPieceView(pieceType: pieceType)
            } else {
                SelectOriginalPieceView(pieceType: pieceType)
            }
        }
    }
}

struct SelectOriginalPieceView : View {
    var pieceType: PieceType
    var thin = false
    // TODO: because of AnyView hack, id is needed so that transitions work
    var body: some View {
        switch self.pieceType {
        case .Bishop:
            return AnyView(Pieces.Bishop(thin: thin)).id("Bishop")
        case .Gold:
            return AnyView(Pieces.Gold()).id("Gold")
        case .Silver:
            return AnyView(Pieces.Silver(thin: thin)).id("Silver")
        case .King:
            return AnyView(Pieces.King()).id("King")
        case .Lance:
            return AnyView(Pieces.Lance(thin: thin)).id("Lance")
        case .Rook:
            return AnyView(Pieces.Rook(thin: thin)).id("Rook")
        case .Pawn:
            return AnyView(Pieces.Pawn(thin: thin)).id("Pawn")
        case .Knight:
            return AnyView(Pieces.Knight(thin: thin)).id("Knight")
        }
    }
}

struct SelectPromotedPieceView : View {
    var pieceType: PieceType
    // TODO: because of AnyView hack, id is needed so that transitions work
    var body: some View {
        switch self.pieceType {
        case .Bishop:
            return AnyView(Pieces.DragonHorse()).id("DragonHorse")
        case .Gold:
            return AnyView(Pieces.Gold()).id("Gold")
        case .Silver:
            return AnyView(Pieces.PromotedSilver()).id("PromotedSilver")
        case .King:
            return AnyView(Pieces.King()).id("King")
        case .Lance:
            return AnyView(Pieces.PromotedLance()).id("PromotedLance")
        case .Rook:
            return AnyView(Pieces.DragonKing()).id("DragonKing")
        case .Pawn:
            return AnyView(Pieces.PromotedPawn()).id("PromotedPawn")
        case .Knight:
            return AnyView(Pieces.PromotedKnight()).id("PromotedKnight")
        }
    }
}

private extension PieceType {
    var scale: CGFloat {
        get {
            switch self {
            case .Bishop, .King, .Rook:
                return CGFloat(1)
            case .Gold, .Silver:
                return  CGFloat(0.9)
            case .Knight, .Lance:
                return CGFloat(0.8)
            case .Pawn:
                return CGFloat(0.7)
            }
        }
    }
}

fileprivate extension Piece {
    var direction: Direction {
        self.owner == .gote ? .opposite : .default
    }
}
