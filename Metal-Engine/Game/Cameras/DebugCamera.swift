//
//  DebugCamera.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import simd
import AppKit

final class DebugCamera : Camera {
    var cameraType: CameraTypes = .Debug
    var position: float3 = float3(0)
    var velocity: float3 = float3(0)
    var rotation: float3 = float3(0)
    var isCursorLocked: Bool = false
    
    let moveAccel: Float = 0.3
    let verticalSpeed: Float = 3
    let mouseSensitivity: Float = 0.15
    
    var projectionMatrix: matrix_float4x4 {
        return matrix_float4x4.perspective(degreesFov: 45,
                                           aspectRatio: Renderer.AspectRatio,
                                           near: 0.1,
                                           far: 1000)
    }

    func update(deltaTime: Float) {
        if (Keyboard.IsKeyPressed(.a)) {
            self.velocity.z += sin(self.rotation.y)*deltaTime*moveAccel
            self.velocity.x -= cos(self.rotation.y)*deltaTime*moveAccel
        }
        if (Keyboard.IsKeyPressed(.d)) {
            self.velocity.z -= sin(self.rotation.y)*deltaTime*moveAccel
            self.velocity.x += cos(self.rotation.y)*deltaTime*moveAccel
        }
        if (Keyboard.IsKeyPressed(.w)) {
            self.velocity.z -= cos(self.rotation.y)*deltaTime*moveAccel
            self.velocity.x -= sin(self.rotation.y)*deltaTime*moveAccel
        }
        if (Keyboard.IsKeyPressed(.s)) {
            self.velocity.z += cos(self.rotation.y)*deltaTime*moveAccel
            self.velocity.x += sin(self.rotation.y)*deltaTime*moveAccel
        }
        if (Keyboard.IsKeyPressed(.space)) {
            self.position.y += deltaTime*verticalSpeed
        }
        if (Keyboard.IsKeyPressed(.shift)) {
            self.position.y -= deltaTime*verticalSpeed
        }
        if (Mouse.IsMouseButtonPressed(button: .left)) {
            isCursorLocked = true
            CGAssociateMouseAndMouseCursorPosition(boolean_t(truncating: false))
            NSCursor.hide()
            
            let unitVector = RotationToUnitVector(rotation: self.rotation)
            let callback = { (coord: float3) -> Bool in return ((voxelManager.grid.block(at: Position3D(coord))?.type ?? VoxelType.Air) != VoxelType.Air) }
            let impact = VoxelRaycast.raycast(origin: self.position, direction: unitVector, radius: 20, callback: callback)
            if (impact != nil) {
                voxelManager.grid.changeBlock(at: Position3D(impact!), voxel: Voxel(VoxelType.Air))
                let chunkPosition: Position = voxelManager.grid.getChunkPosition(at: Position(impact!.x, impact!.z))
                let renderable: RenderableChunk = voxelManager.loadedChunks.first(where: {$0.gridPosition == chunkPosition})!
                voxelManager.updateQueue.enqueue(renderable)
            }
        }
        if (Keyboard.IsKeyPressed(.escape)) {
            isCursorLocked = false
            CGAssociateMouseAndMouseCursorPosition(boolean_t(truncating: true))
            NSCursor.unhide()
        }
        if (isCursorLocked) {
            self.rotation.x -= deltaTime*Mouse.GetDY()*mouseSensitivity
            self.rotation.y -= deltaTime*Mouse.GetDX()*mouseSensitivity
        }
        self.position += self.velocity
        self.velocity -= self.velocity/35
    }
}
