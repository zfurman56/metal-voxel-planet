//
//  Node.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

class Node {
    
    var position: float3 = float3(0)
    var scale: float3 = float3(1)
    var rotation: float3 = float3(0)
    
    var prev_position: float3 = float3(0)
    var prev_scale: float3 = float3(1)
    var prev_rotation: float3 = float3(0)
    
    // Cache computations of model and normal matrices
    var _modelMatrix = matrix_identity_float4x4
    var _normalMatrix = matrix_identity_float3x3
    
    var modelMatrix: matrix_float4x4 {
        if ((prev_position != position) || (prev_scale != scale) || (prev_rotation != rotation)) {
            _modelMatrix = matrix_identity_float4x4
            _modelMatrix.translate(direction: position)
            _modelMatrix.rotate(angle: rotation.x, axis: X_AXIS)
            _modelMatrix.rotate(angle: rotation.y, axis: Y_AXIS)
            _modelMatrix.rotate(angle: rotation.z, axis: Z_AXIS)
            _modelMatrix.scale(axis: scale)
            prev_position = position
            prev_scale = scale
            prev_rotation = rotation
        }
        return _modelMatrix
    }
    
    var normalMatrix: matrix_float3x3 {
        if ((prev_position != position) || (prev_scale != scale) || (prev_rotation != rotation)) {
            let column: simd_float4 = self.modelMatrix.columns.0
            let arraySlice = column.xyz
            let newSubArray = Array(arrayLiteral: arraySlice)
            _normalMatrix = float3x3(self.modelMatrix.columns.0.xyz, self.modelMatrix.columns.1.xyz, self.modelMatrix.columns.2.xyz)
            _normalMatrix = _normalMatrix.inverse.transpose
            prev_position = position
            prev_scale = scale
            prev_rotation = rotation
        }
        return _normalMatrix
    }
    
    var children: [Node] = []
    
    func addChild(_ child: Node) {
        children.append(child)
    }
    
    // Recursively update all children
    func update(deltaTime: Float) {
        for child in children {
            child.update(deltaTime: deltaTime)
        }
    }
    
    // Recursively render all children
    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        for child in children {
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        
        if let renderable = self as? Renderable {
            renderable.doRender(renderCommandEncoder)
        }
    }
    
}



extension simd_float4
{
    var xyz: simd_float3 { simd_float3(x: self.x, y: self.y, z: self.z) }
}
