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
    
    override func buildScene() {
        light = Light(color: float3(1.0,1.0,1.0), direction: float3(0.0, 0.9, 0.435889894354), ambientIntensity: 0.05, diffuseIntensity: 0.9)
        addCamera(debugCamera)
        debugCamera.position.y = 18
        debugCamera.position.z = 10
        for z in 0..<16 {
            for x in 0..<16 {
                theGrid.changeBlock(at: Position3D(x, 15, z), exec: { $0.type = VoxelType.Air })
            }
        }
        theTerrain.chunks[0].updateMesh()
        
        addChild(theTerrain.chunks[0])
    }
    
//    override func update(deltaTime: Float) {
//        theTerrain.chunks[0].updateMesh()
//        super.update(deltaTime: deltaTime)
//    }
}
