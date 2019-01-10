//
//  Types.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import simd

// Syntactic sugar for MemoryLayout
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

// Optional array access - returns nil if element does not exist
extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UInt16: sizeable {}
extension Float: sizeable {}
extension float2: sizeable {}
extension float3: sizeable {}
extension float4: sizeable {}

struct Vertex: sizeable {
    var position: float3
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
    var modelMatrix = matrix_identity_float4x4
    var viewProjectionMatrix = matrix_identity_float4x4
    var normalMatrix = matrix_identity_float3x3
    var cameraPosition = float3(0)
}

// copied from https://github.com/raywenderlich/swift-algorithm-club/tree/master/Queue
public struct Queue<T> {
    fileprivate var array = ContiguousArray<T?>()
    fileprivate var head = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return array.count - head
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        
        array[head] = nil
        head += 1
        
        let percentage = Double(head)/Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        
        return element
    }
    
    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}
