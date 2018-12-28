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

protocol Mesh {
    var vertexBuffer: MTLBuffer! { get }
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

class Cube_Prefab: Prefab {
    override func createVertices() {
        vertices = [
            //Left
            Vertex(position: float3(-1.0,-1.0,-1.0), texel: float2(0, 1), normals: float3(-1, 0, 0)),
            Vertex(position: float3(-1.0,-1.0, 1.0), texel: float2(0, 0), normals: float3(-1, 0, 0)),
            Vertex(position: float3(-1.0, 1.0, 1.0), texel: float2(1, 0), normals: float3(-1, 0, 0)),
            Vertex(position: float3(-1.0,-1.0,-1.0), texel: float2(0, 1), normals: float3(-1, 0, 0)),
            Vertex(position: float3(-1.0, 1.0, 1.0), texel: float2(1, 0), normals: float3(-1, 0, 0)),
            Vertex(position: float3(-1.0, 1.0,-1.0), texel: float2(1, 1), normals: float3(-1, 0, 0)),
            
            //RIGHT
            Vertex(position: float3( 1.0, 1.0, 1.0), texel: float2(1, 0), normals: float3(1, 0, 0)),
            Vertex(position: float3( 1.0,-1.0,-1.0), texel: float2(0, 1), normals: float3(1, 0, 0)),
            Vertex(position: float3( 1.0, 1.0,-1.0), texel: float2(1, 1), normals: float3(1, 0, 0)),
            Vertex(position: float3( 1.0,-1.0,-1.0), texel: float2(0, 1), normals: float3(1, 0, 0)),
            Vertex(position: float3( 1.0, 1.0, 1.0), texel: float2(1, 0), normals: float3(1, 0, 0)),
            Vertex(position: float3( 1.0,-1.0, 1.0), texel: float2(0, 0), normals: float3(1, 0, 0)),
            
            //TOP
            Vertex(position: float3( 1.0, 1.0, 1.0), texel: float2(1, 0), normals: float3(0, 1, 0)),
            Vertex(position: float3( 1.0, 1.0,-1.0), texel: float2(1, 1), normals: float3(0, 1, 0)),
            Vertex(position: float3(-1.0, 1.0,-1.0), texel: float2(0, 1), normals: float3(0, 1, 0)),
            Vertex(position: float3( 1.0, 1.0, 1.0), texel: float2(1, 0), normals: float3(0, 1, 0)),
            Vertex(position: float3(-1.0, 1.0,-1.0), texel: float2(0, 1), normals: float3(0, 1, 0)),
            Vertex(position: float3(-1.0, 1.0, 1.0), texel: float2(0, 0), normals: float3(0, 1, 0)),
            
            //BOTTOM
            Vertex(position: float3( 1.0,-1.0, 1.0), texel: float2(1, 0), normals: float3(0, -1, 0)),
            Vertex(position: float3(-1.0,-1.0,-1.0), texel: float2(0, 1), normals: float3(0, -1, 0)),
            Vertex(position: float3( 1.0,-1.0,-1.0), texel: float2(1, 1), normals: float3(0, -1, 0)),
            Vertex(position: float3( 1.0,-1.0, 1.0), texel: float2(1, 0), normals: float3(0, -1, 0)),
            Vertex(position: float3(-1.0,-1.0, 1.0), texel: float2(0, 0), normals: float3(0, -1, 0)),
            Vertex(position: float3(-1.0,-1.0,-1.0), texel: float2(0, 1), normals: float3(0, -1, 0)),
            
            //BACK
            Vertex(position: float3( 1.0, 1.0,-1.0), texel: float2(1, 0), normals: float3(0, 0, -1)),
            Vertex(position: float3(-1.0,-1.0,-1.0), texel: float2(0, 1), normals: float3(0, 0, -1)),
            Vertex(position: float3(-1.0, 1.0,-1.0), texel: float2(0, 0), normals: float3(0, 0, -1)),
            Vertex(position: float3( 1.0, 1.0,-1.0), texel: float2(1, 0), normals: float3(0, 0, -1)),
            Vertex(position: float3( 1.0,-1.0,-1.0), texel: float2(1, 1), normals: float3(0, 0, -1)),
            Vertex(position: float3(-1.0,-1.0,-1.0), texel: float2(0, 1), normals: float3(0, 0, -1)),
            
            //FRONT
            Vertex(position: float3(-1.0, 1.0, 1.0), texel: float2(0, 0), normals: float3(0, 0, 1)),
            Vertex(position: float3(-1.0,-1.0, 1.0), texel: float2(0, 1), normals: float3(0, 0, 1)),
            Vertex(position: float3( 1.0,-1.0, 1.0), texel: float2(1, 1), normals: float3(0, 0, 1)),
            Vertex(position: float3( 1.0, 1.0, 1.0), texel: float2(1, 0), normals: float3(0, 0, 1)),
            Vertex(position: float3(-1.0, 1.0, 1.0), texel: float2(0, 0), normals: float3(0, 0, 1)),
            Vertex(position: float3( 1.0,-1.0, 1.0), texel: float2(1, 1), normals: float3(0, 0, 1))
        ]
    }
}

class MeshLibrary {
    private static var meshes: [Mesh] = []
    
    public static func Initialize() {
        createDefaultMeshes()
    }
    
    private static func createDefaultMeshes(){
        meshes.insert(Cube_Prefab(), at: PrefabTypes.CubePrefab.rawValue)
    }
    
    public static func Mesh(_ meshType: PrefabTypes)->Mesh{
        return meshes[meshType.rawValue]
    }
}

