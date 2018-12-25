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
        addCamera(debugCamera)
        debugCamera.position.z = 5
        addChild(cube)
    }
    
    override func update(deltaTime: Float) {
        cube.rotation.x += deltaTime
        cube.rotation.y += deltaTime
        super.update(deltaTime: deltaTime)
    }
}
