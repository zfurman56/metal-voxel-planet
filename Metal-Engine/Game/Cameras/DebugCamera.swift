//
//  DebugCamera.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import simd

class DebugCamera : Camera {
    var cameraType: CameraTypes = .Debug
    var position: float3 = float3(0)
    
    var projectionMatrix: matrix_float4x4 {
        return matrix_float4x4.perspective(degreesFov: 45,
                                           aspectRatio: Renderer.AspectRatio,
                                           near: 0.1,
                                           far: 1000)
    }

    func update(deltaTime: Float) {
        if (Keyboard.IsKeyPressed(.leftArrow)) {
            self.position.x -= deltaTime
        }
        if (Keyboard.IsKeyPressed(.rightArrow)) {
            self.position.x += deltaTime
        }
        if (Keyboard.IsKeyPressed(.upArrow)) {
            self.position.y += deltaTime
        }
        if (Keyboard.IsKeyPressed(.downArrow)) {
            self.position.y -= deltaTime
        }
    }
}
