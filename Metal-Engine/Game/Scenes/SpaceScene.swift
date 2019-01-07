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
    let gravityCoef: Float = 100000
    
    override func buildScene() {
        light = Light(color: float3(1.0,1.0,1.0), direction: float3(0.0, 0.9, 0.435889894354), ambientIntensity: 0.05, diffuseIntensity: 0.9)
        
        ballisticCamera.position.z = 130
        
        var transform = matrix_identity_float4x4
        transform.rotate(angle: Float(90).toRadians, axis: X_AXIS)
        transform.scale(axis: float3(0.1))
        
        let velocity4 = simd_make_float4(CameraManager.cameras["surface"]?.velocity ?? float3(0)) + float4(0,0,0,1)
        ballisticCamera.velocity = simd_make_float3(transform * velocity4)
        
        addCamera(ballisticCamera, "space")
        
        sphere.scale = float3(100)
        addChild(sphere)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        super.render(renderCommandEncoder: renderCommandEncoder)
    }
    
    override func update(deltaTime: Float) {
        let diff = sphere.position-ballisticCamera.position
        ballisticCamera.addForce(force: (gravityCoef/simd_length(diff*diff))*simd_normalize(diff), deltaTime: deltaTime)
        super.update(deltaTime: deltaTime)
        
        if (simd_length(diff) < 110) {
            SceneManager.SetScene(.Surface)
        }
    }
}
