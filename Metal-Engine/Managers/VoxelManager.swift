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
    
    // The chunk the camera is over
    var currentChunk: Position = Position(0, 0)
    
    init() {
        self.terrain.chunks.append(RenderableChunk(position: Position(0, 0)))
    }
    
    public func update() {
        // Find out if the camera moved into a different chunk - that would
        // mean that we have work to do
        let cameraPos = SceneManager.currentScene.cameraManager.currentCamera.position
        let chunkPosition = (self.grid.getChunkPosition(at: Position(cameraPos.x, cameraPos.z)))
        if (chunkPosition != currentChunk) {
            currentChunk = chunkPosition
        }
        
        createChunks()
        updateChunks()
    }
    
    private func createChunks() {
        
    }
    
    private func updateChunks() {
        
    }
    
    public func renderChunks() {
        
    }
}
