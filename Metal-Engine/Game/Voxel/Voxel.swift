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

class Voxel {
    var type: VoxelType
    init(_ type: VoxelType) {
        self.type = type
    }
}

struct Position: Hashable {
    let x: Int
    let z: Int
    
    init(_ x: Int, _ z: Int) {
        self.x = x
        self.z = z
    }
    
    init(_ x: Float, _ z: Float) {
        self.x = Int(x)
        self.z = Int(z)
    }
}

struct Position3D {
    let x: Int
    let y: Int
    let z: Int
    
    init(_ x: Int, _ y:Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(_ x: Float, _ y: Float, _ z: Float) {
        self.x = Int(x)
        self.y = Int(y)
        self.z = Int(z)
    }
    
    init(_ vec: float3) {
        self.x = Int(vec.x)
        self.y = Int(vec.y)
        self.z = Int(vec.z)
    }
}

class Chunk {
    var position: Position
    var blocks: [[[Voxel]]]

    init(position: Position) {
        self.position = position
        self.blocks = [[[Voxel]]](elementCreator: [[Voxel]](elementCreator: [Voxel](elementCreator: Voxel(.Air), count: 16), count: 16), count: 16)
    }
}


// Internal representation of voxel grid - see VoxelTerrain for rendering
class VoxelGrid {
    var chunks: [Position: Chunk] = [:]
    
    init() {
        self.chunks.updateValue(Chunk(position: Position(0, 0)), forKey: Position(0, 0))
    }
    
    func getChunkPosition(at coord: Position)->Position {
        return Position(coord.x>>4, coord.z>>4)
    }
    
    func getChunk(at coord: Position)->Chunk? {
        let chunkCoord = Position(coord.x>>4, coord.z>>4)
        return chunks[chunkCoord]
    }
    
    func block(at coord: Position3D)->Voxel? {
        let chunkCoord = Position(coord.x>>4, coord.z>>4)
        let blockOffset = Position3D((coord.x<<28)>>28, coord.y, (coord.z<<28)>>28)
//        print("Coord: \(coord)")
//        print(blockOffset)
        let selectedChunk = chunks[chunkCoord]
        return selectedChunk?.blocks[safe: Int(blockOffset.y)]?[safe: Int(blockOffset.z)]?[safe: Int(blockOffset.x)]
    }
    
    // Closure necessary because structs are pass-by-value and do not modify
    // the original when returned from a function
    func changeBlock(at coord: Position3D, exec: (Voxel)->()) {
        let chunkCoord = Position(coord.x>>4, coord.z>>4)
        let blockOffset = Position3D((coord.x<<28)>>28, coord.y, (coord.z<<28)>>28)
        var selectedChunk = chunks[chunkCoord]!
        exec(selectedChunk.blocks[Int(blockOffset.y)][Int(blockOffset.z)][Int(blockOffset.x)])
    }
}
