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
    init(_ type: VoxelType) {
        self.type = type
    }
}

struct Position: Hashable {
    let x: Int32
    let z: Int32
    
    init(_ x: Int32, _ z: Int32) {
        self.x = x
        self.z = z
    }
    
    init(_ x: Float, _ z: Float) {
        self.x = Int32(x)
        self.z = Int32(z)
    }
}

struct Position3D {
    let x: Int32
    let y: Int32
    let z: Int32
    
    init(_ x: Int32, _ y: Int32, _ z: Int32) {
        self.x = Int32(x)
        self.y = Int32(y)
        self.z = Int32(z)
    }
    
    init(_ x: Float, _ y: Float, _ z: Float) {
        self.x = Int32(x)
        self.y = Int32(y)
        self.z = Int32(z)
    }
    
    init(_ vec: float3) {
        self.x = Int32(vec.x)
        self.y = Int32(vec.y)
        self.z = Int32(vec.z)
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
final class VoxelGrid {
    var chunks: [Position: Chunk] = [:]
    var cache: Chunk?
    
    func getChunkPosition(at coord: Position)->Position {
        return Position(coord.x>>4, coord.z>>4)
    }
    
    func getChunk(at coord: Position)->Chunk? {
        return chunks[coord]
    }
    
    func block(at coord: Position3D)->Voxel? {
        let chunkCoord = Position(coord.x>>4, coord.z>>4)
        let blockOffset = Position3D(Int32(UInt32(bitPattern: coord.x<<28)>>28), coord.y, Int32(UInt32(bitPattern: coord.z<<28)>>28))
        if (cache?.position != chunkCoord) {
            cache = chunks[chunkCoord]
        }
        return cache?.blocks[safe: Int(blockOffset.y)]?[safe: Int(blockOffset.z)]?[safe: Int(blockOffset.x)]
    }
    
    // Closure necessary because structs are pass-by-value and do not modify
    // the original when returned from a function
    func changeBlock(at coord: Position3D, voxel: Voxel) {
        let chunkCoord = Position(coord.x>>4, coord.z>>4)
        let blockOffset = Position3D(Int32(UInt32(bitPattern: coord.x<<28)>>28), coord.y, Int32(UInt32(bitPattern: coord.z<<28)>>28))
        if (cache?.position != chunkCoord) {
            cache = chunks[chunkCoord]
        }
        cache!.blocks[Int(blockOffset.y)][Int(blockOffset.z)][Int(blockOffset.x)] = voxel
    }
}
