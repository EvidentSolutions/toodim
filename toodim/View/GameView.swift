//
//  ContentView.swift
//  toodim
//
//  Created by Henrik Huttunen on 10.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var game: GameVM
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack() {
                    Button("Reset") {
                        self.game.startNewGame()
                    }
                    Button("Undo") {
                        self.game.undo()
                    }
                }.padding(3)
                VStack() {
                    PlayerName(player: self.game.player1)
                        .direction(.opposite)
                    CapturedPieces(pieces: self.game.capturedPiecesSente)
                    ZStack {
                        GeometryReader { geo in
                            Board()
                            LastMoveView(move: self.game.game.lastMove, containerSize: geo.size)
                        }
                    }
                    CapturedPieces(pieces: self.game.capturedPiecesGote)
                    PlayerName(player: self.game.player2)
                }
                    .environmentObject(self.game)
                    .direction(.opposite)
            }
        }
        
    }
}

struct PlayerName : View {
    var player: PlayerVM

    var body: some View {
        Text(player.info)
            .padding(3)
            .background(player.isTurn ? Color.yellow : Color.clear)
            .scaleEffect(player.winner != nil || player.isTurn ? 1 : 0.8)
            .fixedSize(horizontal: true, vertical: true)

    }
}

struct CapturedPieces : View {
    var pieces: [PieceVM]
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    var capturedBoardHeigth: CGFloat {
        horizontalSizeClass == .compact ? 50 : 100
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                HStack {
                    ForEach(self.pieces) { piece in
                        SelectablePieceView(selectablePiece: piece)
                    }
                }
            }
            .padding(3)
            .foregroundColor(Color(UIColor.board))
            .clipped()
        }
        .frame(height: self.capturedBoardHeigth)
    }
}

struct Board : View {
    
    @EnvironmentObject var game: GameVM

    var body: some View {
        GeometryReader { geometry in
            Group {
                LinearGradient(
                    gradient: Gradient(colors: [Color(UIColor.board), Color(UIColor.board2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                    .mask(
                        Rectangle()
                            .size(minSquare(size: geometry.size))
                            .offset(getOffset(for: Position(column: 1, row: 1), containerSize: geometry.size)))
                    .scaleEffect(1.02)


                ZStack {
                    ForEach(self.game.squares) { square in
                        PositionedSquare(
                            size: geometry.size, position: square.position, piece: square.piece,
                                    hasMovablePosition: square.hasMovablePosition,
                                    hasKingInCheck: square.hasKingInCheck)
                    }
                }

                ForEach(self.game.piecesOnBoard) { piece in
                    PieceOnBoard(piece: piece, size: geometry.size)
                        .animation(.spring())
                }
                
            }
        }
    }
    
}

struct PieceOnBoard : View {
    
    @EnvironmentObject var game: GameVM

    var piece: PieceVM
    var position: Position {
        self.piece.piece.position!
    }
    
    var size: CGSize
    
    var body: some View {
        SelectablePieceView(selectablePiece: piece)
            .frame(width: getItemSize(containerSize: size),
                   height: getItemSize(containerSize: size))
            .offset(getOffset(for: position, containerSize: size))
    }
}

struct PositionedSquare : View {
    var size: CGSize
    var position: Position
    var piece: Piece?
    var hasMovablePosition: Bool
    var hasKingInCheck: Bool
    @EnvironmentObject var game: GameVM
    
    var body : some View {
        BoardSquare(hasMovablePosition: hasMovablePosition,
                    hasKingInCheck: hasKingInCheck,
                    piece: piece)
            .frame(width: getItemSize(containerSize: size),
                   height: getItemSize(containerSize: size))
            .offset(getOffset(for: position, containerSize: size))
            .gesture(moveSelectedPieceGesture(position, game))
    }
}


struct BoardSquare : View {

    @EnvironmentObject var game: GameVM
    
    var hasMovablePosition: Bool
    var hasKingInCheck: Bool
    var piece: Piece?
    var color: Color {
        if (hasKingInCheck) {
            return Color(UIColor.kingInCheck)
        } else if !hasMovablePosition {
            return Color.clear
        } else {
            return Color(UIColor.movableLocation)
        }
    }
    
    var body: some View {
        Rectangle()
            .fill(color)
            .border(Color.black, width: 0.5)
    }
    
}

struct SelectablePieceView: View {
    @EnvironmentObject var game: GameVM

    var selectablePiece: PieceVM

    var piece: Piece {
        selectablePiece.piece
    }
    
    var body: some View {
        // TODO not properly done: moveSelectedPiece is called when selectPieceGesture works
        // ExclusiveGesture might be helpful but including?
        PieceView(piece: piece)
            .gesture(promotePieceGesture(piece, game), including: piece.isPromotable ? .all : .subviews)
            .simultaneousGesture(moveSelectedPieceGesture(piece.position, game), including: selectablePiece.movingAllowed ? .all : .all)
            .simultaneousGesture(selectPieceGesture(piece, game), including: selectablePiece.selectionAllowed ? .all : .subviews)
    }


    
}
