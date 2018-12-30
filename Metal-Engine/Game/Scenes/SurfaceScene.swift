//
//  SurfaceScene.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/27/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import simd
import Noise

class SurfaceScene : Scene {
    let debugCamera = DebugCamera()
    
    override func buildScene() {
        light = Light(color: float3(1.0,1.0,1.0), direction: float3(0.0, 0.9, 0.435889894354), ambientIntensity: 0.05, diffuseIntensity: 0.9)
        addCamera(debugCamera)
        debugCamera.position.y = 18
        debugCamera.position.z = 10
        
//        let noise = SuperSimplexNoise2D(amplitude: 4, frequency: 0.05, seed: Preferences.WorldSeed)
//        for sample in noise.sample_area(width: 16, height: 16) {
//            for x in 0..<Int(8+sample.2) {
//                voxelManager.grid.changeBlock(at: Position3D(Int(sample.0), x, Int(sample.1)), exec: { $0.type = VoxelType.Dirt })
//            }
//        }
        
        TerrainGenerationLibrary.getTerrain(.Basic).createChunkTerrain(start: Position(x: 0, y: 0))
        voxelManager.terrain.chunks[0].updateMesh()
        
        addChild(voxelManager.terrain.chunks[0])
    }
    
//    override func update(deltaTime: Float) {
//        voxelManager.terrain.chunks[0].updateMesh()
//        super.update(deltaTime: deltaTime)
//    }
}
