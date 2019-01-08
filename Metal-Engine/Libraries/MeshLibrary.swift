//
//  MeshLibrary.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

enum PrefabTypes : Int {
    case CubePrefab
}

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

class Prefab: Mesh {
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    var vertexCount: Int! {
        return vertices.count
    }
    
    init() {
        createVertices()
        createBuffers()
    }
    
    func createVertices() {}
    
    func createBuffers() {
        vertexBuffer = Engine.Device.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: [])
    }
}

// Global singleton, manages prefab selection
final class MeshLibrary {
    private static var meshes: [Mesh] = []
    
    public static func Initialize() {
        createDefaultMeshes()
    }
    
    private static func createDefaultMeshes() {}
    
    public static func Mesh(_ meshType: PrefabTypes)->Mesh{
        return meshes[meshType.rawValue]
    }
}

