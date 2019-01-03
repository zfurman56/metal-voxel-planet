//
//  SpaceScene.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/31/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

class SpaceScene : Scene {
    let ballisticCamera = BallisticCamera()
    let sphere = DynamicSphere()
    
    override func buildScene() {
        light = Light(color: float3(1.0,1.0,1.0), direction: float3(0.0, 0.9, 0.435889894354), ambientIntensity: 0.05, diffuseIntensity: 0.9)
        
        ballisticCamera.position.z = 220
        addCamera(ballisticCamera)
        
        sphere.scale = float3(100)
        addChild(sphere)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        super.render(renderCommandEncoder: renderCommandEncoder)
    }
    
    override func update(deltaTime: Float) {
        super.update(deltaTime: deltaTime)
    }
}
