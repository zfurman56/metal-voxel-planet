//
//  GameObject.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

class GameObject : Node {
    
    var uniforms = Uniforms()
    
    var time: Float = 0
    override func update(deltaTime: Float) {
        time += deltaTime
        updateUniforms()
    }
    
    private func updateUniforms() {
        uniforms.modelViewMatrix = CameraManager.currentCamera.viewMatrix * self.modelMatrix
        uniforms.projectionMatrix = CameraManager.currentCamera.projectionMatrix
        uniforms.normalMatrix = self.normalMatrix
    }

}

