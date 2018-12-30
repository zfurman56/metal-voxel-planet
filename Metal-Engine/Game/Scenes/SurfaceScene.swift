//
//  SurfaceScene.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/27/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit
import Noise

class SurfaceScene : Scene {
    let debugCamera = DebugCamera()
    
    override func buildScene() {
        light = Light(color: float3(1.0,1.0,1.0), direction: float3(0.0, 0.9, 0.435889894354), ambientIntensity: 0.05, diffuseIntensity: 0.9)
        addCamera(debugCamera)
        debugCamera.position.y = 18
        debugCamera.position.z = 10
        
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        super.render(renderCommandEncoder: renderCommandEncoder)
        voxelManager.renderChunks(renderCommandEncoder: renderCommandEncoder)
    }
    
    override func update(deltaTime: Float) {
        voxelManager.update()
        voxelManager.renderUpdate(deltaTime: deltaTime)
        super.update(deltaTime: deltaTime)
    }
    
//    override func update(deltaTime: Float) {
//        voxelManager.terrain.chunks[0].updateMesh()
//        super.update(deltaTime: deltaTime)
//    }
}
