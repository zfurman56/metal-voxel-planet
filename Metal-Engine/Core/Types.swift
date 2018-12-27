//
//  Types.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import simd

protocol sizeable {}
extension sizeable {
    static var size: Int {
        return MemoryLayout<Self>.size
    }

    static var stride: Int {
        return MemoryLayout<Self>.stride
    }

    static func size(_ count: Int)->Int {
        return MemoryLayout<Self>.size * count
    }

    static func stride(_ count: Int)->Int {
        return MemoryLayout<Self>.stride * count
    }
    
    static func memOffset(of key: PartialKeyPath<Self>)->Int {
        return MemoryLayout<Self>.offset(of: key)!
    }
}

extension Float: sizeable {}
extension float2: sizeable {}
extension float3: sizeable {}
extension float4: sizeable {}

struct Vertex: sizeable {
    var position: float3
    var color: float4
    var texel: float2
    var normals: float3
}

struct Light: sizeable {
    var color: float3
    var direction: float3
    var ambientIntensity: Float
    var diffuseIntensity: Float
}

struct ModelConstants: sizeable {
    var modelMatrix = matrix_identity_float4x4
}

struct SceneConstants: sizeable {
    var viewMatrix = matrix_identity_float4x4
    var projectionMatrix = matrix_identity_float4x4
}

struct Uniforms: sizeable {
    var modelViewProjectionMatrix = matrix_identity_float4x4
    var normalMatrix = matrix_identity_float3x3
}
