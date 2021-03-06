//
//  SurfaceScene.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/27/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit
import Noise

// The scene for rendering a planet's surface
class SurfaceScene : Scene {
    let ballisticCamera = BallisticCamera()
    
    override func buildScene() {
        light = Light(color: float3(1.0,1.0,1.0), direction: float3(0.0, 0.9, 0.435889894354), ambientIntensity: 0.05, diffuseIntensity: 0.9)
        addCamera(ballisticCamera, "surface")
        ballisticCamera.position.y = 18
        ballisticCamera.position.z = 10
        
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        super.render(renderCommandEncoder: renderCommandEncoder)
        voxelManager.render(renderCommandEncoder: renderCommandEncoder)
    }
    
    override func update(deltaTime: Float) {
        voxelManager.update()
        voxelManager.renderUpdate(deltaTime: deltaTime)
        
        ballisticCamera.addForce(force: float3(0, -1, 0), deltaTime: deltaTime)
        
        collisionUpdate()
        
        super.update(deltaTime: deltaTime)
        
        if (ballisticCamera.position.y > 200) {
            SceneManager.SetScene(.Space)
        }
    }
    
    private func collisionUpdate() {
        if ((voxelManager.grid.block(at: Position3D(ballisticCamera.position))?.type ?? .Air) != .Air) {
            ballisticCamera.position.y.round(.up)
            ballisticCamera.velocity.y = 0
        }
    }
    
//    override func update(deltaTime: Float) {
//        voxelManager.terrain.chunks[0].updateMesh()
//        super.update(deltaTime: deltaTime)
//    }
}
