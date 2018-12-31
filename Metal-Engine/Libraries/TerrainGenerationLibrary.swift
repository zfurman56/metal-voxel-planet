//
//  TerrainGenerationLibrary.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/29/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit
import Noise

enum TerrainTypes : Int {
    case Basic
}

final class TerrainGenerationLibrary {
    private static var terrains: [TerrainGenerator] = []
    
    public static func Initialize(seed: Int) {
        createDefaultTerrain(seed: seed)
    }
    
    private static func createDefaultTerrain(seed: Int) {
        self.terrains.insert(BasicTerrainGenerator(seed: seed), at: TerrainTypes.Basic.rawValue)
    }
    
    public static func getTerrain(_ terrainType: TerrainTypes)->TerrainGenerator{
        return terrains[terrainType.rawValue]
    }
}

protocol TerrainGenerator: AnyObject {
    var seed: Int {get}

    func getVoxelTerrain(position: Position3D)->VoxelType
    func createChunkTerrain(start: Position)
}

class BasicTerrainGenerator: TerrainGenerator {
    let seed: Int
    let noise: SuperSimplexNoise2D
    
    init(seed: Int) {
        self.seed = seed
        self.noise = SuperSimplexNoise2D(amplitude: 4, frequency: 0.05, seed: seed)
    }
    
    func getVoxelTerrain(position: Position3D)->VoxelType {
        return (position.y <= Int(7 + self.noise.evaluate(Double(position.x), Double(position.z)))) ? VoxelType.Dirt : VoxelType.Air
    }
    
    func createChunkTerrain(start: Position) {
        let chunk = voxelManager.grid.getChunk(at: start)!
        for y: Int32 in 0..<16 {
            for z: Int32 in 0..<16 {
                for x: Int32 in 0..<16 {
                    chunk.blocks[Int(y)][Int(z)][Int(x)].type = getVoxelTerrain(position: Position3D(x+(start.x*16), y, z+(start.z*16)))
                }
            }
        }
    }
}
