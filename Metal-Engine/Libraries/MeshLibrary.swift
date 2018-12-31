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

