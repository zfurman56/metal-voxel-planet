//
//  MeshLibrary.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

protocol Mesh: AnyObject {
    var vertexBuffer: MTLBuffer! { get }
    var vertexCount: Int! { get }
}

protocol SafeMesh: AnyObject {
    var vertexBuffer: MTLBuffer? { get }
    var vertexCount: Int! { get }
}

final class IndexedMesh : Mesh {
    var indexBuffer: MTLBuffer!
    var vertexBuffer: MTLBuffer!
    var vertexCount: Int!
    var indexCount: Int!
    
    init(vertices: [Vertex], indices: [UInt16]) {
        self.vertexCount = vertices.count
        self.indexCount = indices.count
        self.indexBuffer = Engine.Device.makeBuffer(bytes: indices, length: UInt16.stride(indices.count), options: [])
        self.vertexBuffer = Engine.Device.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: [])
    }
}

final class FixedMesh : Mesh {
    var vertexBuffer: MTLBuffer!
    var vertexCount: Int!
    
    init(vertices: [Vertex]) {
        self.vertexCount = vertices.count
        self.vertexBuffer = Engine.Device.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: [])
    }
}

final class SafeFixedMesh : SafeMesh {
    var vertexBuffer: MTLBuffer?
    var vertexCount: Int!
    
    init(vertices: [Vertex]) {
        self.vertexCount = vertices.count
        if (vertices.count > 0) {
            self.vertexBuffer = Engine.Device.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: [])
        } else {
            self.vertexBuffer = nil
        }
    }
}
