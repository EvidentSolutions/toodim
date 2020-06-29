//
//  LayoutCalculation.swift
//  toodim
//
//  Created by Henrik Huttunen on 28.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import SwiftUI


func min(size: CGSize) -> CGFloat {
    min(size.width, size.height)
}

func minSquare(size: CGSize) -> CGSize {
    let value = min(size.width, size.height)
    return CGSize(width: value, height: value)
}

func getOffset(for position: Position, containerSize: CGSize) -> CGSize {
    let size = min (containerSize.width, containerSize.height)
    let itemSize = getItemSize(containerSize: containerSize)
    
    // Compensation to center on the axis that was greater
    let heightCompensation = (containerSize.height - size) / 2
    let widthCompensation = (containerSize.width - size) / 2
    
    return CGSize(width: CGFloat(position.column-1) * itemSize + widthCompensation, height: CGFloat(position.row-1) * itemSize + heightCompensation)
}

func getItemSize(containerSize: CGSize) -> CGFloat {
    let size = min (containerSize.width, containerSize.height)
    return size / CGFloat(Game.boardSize)
}
