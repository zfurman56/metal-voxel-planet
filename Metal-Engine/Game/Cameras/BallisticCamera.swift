//
//  BallisticCamera.swift
//  Metal-Engine
//
//  Created by Zach Furman on 1/3/19.
//  Copyright © 2019 Zach Furman. All rights reserved.
//

import simd
import AppKit

final class BallisticCamera: Camera {
    var cameraType: CameraTypes = .Ballistic
    var position: float3 = float3(0)
    var velocity: float3 = float3(0)
    var rotation: float3 = float3(0)
    var isCursorLocked: Bool = false
    
    let mass: Float = 1.0
    let moveAccel: Float = 3
    let verticalAccel: Float = 2
    let mouseSensitivity: Float = 0.15
    
    var projectionMatrix: matrix_float4x4 {
        return matrix_float4x4.perspective(degreesFov: 45,
                                           aspectRatio: Renderer.AspectRatio,
                                           near: 0.1,
                                           far: 1000)
    }
    
    func update(deltaTime: Float) {
        if (Keyboard.IsKeyPressed(.a)) {
            addForce(force: moveAccel * float3(-cos(self.rotation.y), 0, sin(self.rotation.y)), deltaTime: deltaTime)
        }
        if (Keyboard.IsKeyPressed(.d)) {
            addForce(force: moveAccel * float3(cos(self.rotation.y), 0, -sin(self.rotation.y)), deltaTime: deltaTime)
        }
        if (Keyboard.IsKeyPressed(.w)) {
            addForce(force: moveAccel * float3(-sin(self.rotation.y), 0, -cos(self.rotation.y)), deltaTime: deltaTime)
        }
        if (Keyboard.IsKeyPressed(.s)) {
            addForce(force: moveAccel * float3(sin(self.rotation.y), 0, cos(self.rotation.y)), deltaTime: deltaTime)
        }
        if (Keyboard.IsKeyPressed(.space)) {
            addForce(force: float3(0, verticalAccel, 0), deltaTime: deltaTime)
        }
        if (Keyboard.IsKeyPressed(.shift)) {
            addForce(force: float3(0, -verticalAccel, 0), deltaTime: deltaTime)
        }
        
        if (Mouse.IsMouseButtonPressed(button: .left)) {
            // Hide and lock cursor when window clicked
            isCursorLocked = true
            CGAssociateMouseAndMouseCursorPosition(boolean_t(truncating: false))
            NSCursor.hide()
            
            // See if we clicked a block, if so destroy it
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
            // Unhide and unlock cursor when escape button pressed
            isCursorLocked = false
            CGAssociateMouseAndMouseCursorPosition(boolean_t(truncating: true))
            NSCursor.unhide()
        }
        if (isCursorLocked) {
            self.rotation.x -= deltaTime*Mouse.GetDY()*mouseSensitivity
            self.rotation.y -= deltaTime*Mouse.GetDX()*mouseSensitivity
        }
        
        self.updatePhysics(deltaTime: deltaTime)
    }
}

extension BallisticCamera: PhysicsConformant {}
