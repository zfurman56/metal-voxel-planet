//
//  VoxelManager.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/29/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

let voxelManager = VoxelManager()

class VoxelManager {
    let grid: VoxelGrid = VoxelGrid()
    let terrain: VoxelTerrain = VoxelTerrain()
    
    init() {
        self.terrain.chunks.append(TerrainChunk(position: Position(0, 0)))
    }
    
    func update() {
        
    }
}
