//
//  SurfaceScene.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/27/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import simd

class SurfaceScene : Scene {
    let debugCamera = DebugCamera()
    let cube = Cube()
    let grid = VoxelGrid()
    
    override func buildScene() {
        light = Light(color: float3(1.0,1.0,1.0), direction: float3(0.0, 0.9, 0.435889894354), ambientIntensity: 0.05, diffuseIntensity: 0.9)
        addCamera(debugCamera)
        debugCamera.position.y = 18
        debugCamera.position.z = 10
        grid.terrain[0].chunk.blocks[15][15][15].type = VoxelType.Air
        grid.terrain[0].chunk.blocks[15][15][14].type = VoxelType.Air
        grid.terrain[0].updateMesh()
        
        addChild(grid.terrain[0])
    }
    
//    override func update(deltaTime: Float) {
//        grid.terrain[0].updateMesh()
//        super.update(deltaTime: deltaTime)
//    }
}
