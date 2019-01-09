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
    let farTerrain: FarTerrain = FarTerrain()
    
    // The chunk the camera is over
    var currentChunk: Position = Position(Int32(0), Int32(0))
    
    var loadedChunks: ContiguousArray<RenderableChunk> = []
    var loadQueue: Queue<Position> = Queue<Position>()
    var setupQueue: Queue<Position> = Queue<Position>()
    var unloadQueue: Queue<Position> = Queue<Position>()
    var updateQueue: Queue<RenderableChunk> = Queue<RenderableChunk>()
    
    init() {
        // The initial loaded chunks should be the surrounding ones
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
        let cameraPos = CameraManager.currentCamera.position
        let chunkPosition = (self.grid.getChunkPosition(at: Position(cameraPos.x, cameraPos.z)))
        if (chunkPosition != currentChunk) {
            // We don't have to unload everything and load it again, we can just unload the chunks
            // from the direction we left and load the chunks in the direction we're going
            
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
            
            // Update the far terrain
            farTerrain.updateMesh(center: chunkPosition)
            
            currentChunk = chunkPosition
        }
        
        loadChunks()
        unloadChunks()
        setupChunks()
        updateChunks()
    }
    
    // Create the chunk's block array and fill it with terrain
    private func loadChunks() {
        while (!loadQueue.isEmpty) {
            let position = loadQueue.dequeue()!
            
            self.grid.chunks.updateValue(Chunk(position: position), forKey: position)
            TerrainGenerationLibrary.getTerrain(.Basic).createChunkTerrain(start: position)
            
            setupQueue.enqueue(position)
        }
    }
    
    // Create the actual chunk mesh that gets rendered
    private func setupChunks() {
        while (!setupQueue.isEmpty) {
            let position = setupQueue.dequeue()!
            
            let chunk = RenderableChunk(position: position)
            chunk.updateMesh()
            loadedChunks.append(chunk)
        }
    }
    
    // Remove both the chunk blocks and the chunk mesh from storage
    // Swift's ARC will automatically deallocate them
    private func unloadChunks() {
        while (!unloadQueue.isEmpty) {
            let position = unloadQueue.dequeue()!
            
            self.grid.chunks.removeValue(forKey: position)
            loadedChunks = loadedChunks.filter({$0.gridPosition != position})
        }
    }
    
    // Update any chunk meshes that have been changed
    private func updateChunks() {
        while (!updateQueue.isEmpty) {
            let chunk = updateQueue.dequeue()!
            chunk.updateMesh()
        }
            
    }
    
    // Render every chunk that's loaded and the far terrain
    public func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        for chunk in loadedChunks {
            chunk.render(renderCommandEncoder: renderCommandEncoder)
        }
        farTerrain.render(renderCommandEncoder: renderCommandEncoder)
    }
    
    // Update the rendering uniforms for every loaded chunk and the far terrain
    public func renderUpdate(deltaTime: Float) {
        for chunk in loadedChunks {
            chunk.update(deltaTime: deltaTime)
        }
        farTerrain.update(deltaTime: deltaTime)
    }
}
