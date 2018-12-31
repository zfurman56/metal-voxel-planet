//
//  Camera.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import simd

enum CameraTypes {
    case Debug
}

protocol Camera: AnyObject {
    var cameraType: CameraTypes { get }
    var position: float3 { get set }
    var rotation: float3 { get set }
    var projectionMatrix: matrix_float4x4 { get }
    func update(deltaTime: Float)
}

extension Camera {
    var viewMatrix: matrix_float4x4 {
        var viewMatrix = matrix_identity_float4x4
        viewMatrix.rotate(angle: -rotation.x, axis: X_AXIS)
        viewMatrix.rotate(angle: -rotation.y, axis: Y_AXIS)
        viewMatrix.rotate(angle: -rotation.z, axis: Z_AXIS)
        viewMatrix.translate(direction: -position)
        return viewMatrix
    }
}
