//
//  VoxelGrid.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/26/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import simd

extension Array {
    public init(elementCreator: @autoclosure () -> Element, count: Int) {
        self = (0 ..< count).map { _ in elementCreator() }
    }
}

enum VoxelType: UInt8 {
    case Air    = 0
    case Dirt   = 1
}

struct Voxel {
    var type: VoxelType
}

struct Position {
    let x: Int
    let y: Int
}

struct Chunk {
    var position: Position
    var blocks: [[[Voxel]]]

    init(position: Position) {
        self.position = position
        self.blocks = [[[Voxel]]](repeating: [[Voxel]](repeating: [Voxel](repeating: Voxel(type: .Dirt), count: 16), count: 16), count: 16)
    }
}
