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

class TerrainGenerationLibrary {
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

protocol TerrainGenerator {
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
        return (position.y <= Int(10 + self.noise.evaluate(Double(position.x), Double(position.z)))) ? VoxelType.Dirt : VoxelType.Air
    }
    
    func createChunkTerrain(start: Position) {
        let chunk = voxelManager.grid.getChunk(at: start)!
        for y in 0..<16 {
            for z in 0..<16 {
                for x in 0..<16 {
                    chunk.blocks[y][z][x].type = getVoxelTerrain(position: Position3D(x, y, z))
                }
            }
        }
    }
}