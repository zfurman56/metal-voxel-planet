//
//  SandboxScene.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

class SandboxScene: Scene {
    
    let debugCamera = DebugCamera()
    let cube = Cube()
    
    override func buildScene() {
        light = Light(color: float3(1.0,1.0,1.0), direction: float3(0.0, 0.9, 0.435889894354), ambientIntensity: 0.05, diffuseIntensity: 0.9)
        addCamera(debugCamera)
        debugCamera.position.z = 5
        
        addCubes()
    }

    func addCubes(){
        for z in -8..<8 {
            let posZ = Float(z) + 1
            for x in -8..<8 {
                let posX = Float(x) + 1
                let cube = Cube()
                cube.position.z = posZ
                cube.position.x = posX
                cube.scale = float3(0.4)
                addChild(cube)
            }
        }
    }
    
    override func update(deltaTime: Float) {
        cube.rotation.x += deltaTime
        cube.rotation.y = 0.5
        super.update(deltaTime: deltaTime)
    }
}
