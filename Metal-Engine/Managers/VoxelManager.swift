//
//  VoxelManager.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/29/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

let voxelManager = VoxelManager()

final class VoxelManager {
    let grid: VoxelGrid = VoxelGrid()
    
    // The chunk the camera is over
    var currentChunk: Position = Position(Int32(0), Int32(0))
    
    var loadedChunks: ContiguousArray<RenderableChunk> = []
    var loadQueue: Queue<Position> = Queue<Position>()
    var setupQueue: Queue<Position> = Queue<Position>()
    var unloadQueue: Queue<Position> = Queue<Position>()
    var updateQueue: Queue<RenderableChunk> = Queue<RenderableChunk>()
    
    init() {
        let chunkDist = Int32(Preferences.ChunkDistance)
        for z in -chunkDist...chunkDist {
            for x in -chunkDist...chunkDist {
                loadQueue.enqueue(Position(x, z))
            }
        }
    }
    
    public func update() {
        // Find out if the camera moved into a different chunk - that would
        // mean that we have work to do
        let cameraPos = SceneManager.currentScene.cameraManager.currentCamera.position
        let chunkPosition = (self.grid.getChunkPosition(at: Position(cameraPos.x, cameraPos.z)))
        if (chunkPosition != currentChunk) {
            let chunkDist = Int32(Preferences.ChunkDistance)
            
            // We moved left
            if (chunkPosition.x < currentChunk.x) {
                for z in -chunkDist...chunkDist {
                    loadQueue.enqueue(Position(currentChunk.x-chunkDist-1, chunkPosition.z+z))
                    unloadQueue.enqueue(Position(currentChunk.x+chunkDist, chunkPosition.z+z))
                }
            // We moved right
            } else if (chunkPosition.x > currentChunk.x) {
                for z in -chunkDist...chunkDist {
                    loadQueue.enqueue(Position(currentChunk.x+chunkDist+1, chunkPosition.z+z))
                    unloadQueue.enqueue(Position(currentChunk.x-chunkDist, chunkPosition.z+z))
                }
            // We moved back
            } else if (chunkPosition.z < currentChunk.z) {
                for x in -chunkDist...chunkDist {
                    loadQueue.enqueue(Position(chunkPosition.x+x, currentChunk.z-chunkDist-1))
                    unloadQueue.enqueue(Position(chunkPosition.x+x, currentChunk.z+chunkDist))
                }
            // We moved forward
            } else {
                for x in -chunkDist...chunkDist {
                    loadQueue.enqueue(Position(chunkPosition.x+x, currentChunk.z+chunkDist+1))
                    unloadQueue.enqueue(Position(chunkPosition.x+x, currentChunk.z-chunkDist))
                }
            }
            currentChunk = chunkPosition
        }
        
        loadChunks()
        unloadChunks()
        setupChunks()
        updateChunks()
    }
    
    private func loadChunks() {
        while (!loadQueue.isEmpty) {
            let position = loadQueue.dequeue()!
            
            self.grid.chunks.updateValue(Chunk(position: position), forKey: position)
            TerrainGenerationLibrary.getTerrain(.Basic).createChunkTerrain(start: position)
            
            setupQueue.enqueue(position)
        }
    }
    
    private func setupChunks() {
        while (!setupQueue.isEmpty) {
            let position = setupQueue.dequeue()!
            
            let chunk = RenderableChunk(position: position)
            chunk.updateMesh()
            loadedChunks.append(chunk)
        }
    }
    
    private func unloadChunks() {
        while (!unloadQueue.isEmpty) {
            let position = unloadQueue.dequeue()!
            
            self.grid.chunks.removeValue(forKey: position)
            loadedChunks = loadedChunks.filter({$0.gridPosition != position})
        }
    }
    
    private func updateChunks() {
        while (!updateQueue.isEmpty) {
            let chunk = updateQueue.dequeue()!
            chunk.updateMesh()
        }
            
    }
    
    public func renderChunks(renderCommandEncoder: MTLRenderCommandEncoder) {
        for chunk in loadedChunks {
            chunk.render(renderCommandEncoder: renderCommandEncoder)
        }
    }
    
    public func renderUpdate(deltaTime: Float) {
        for chunk in loadedChunks {
            chunk.update(deltaTime: deltaTime)
        }
    }
}
