//
//  DynamicSphere.swift
//  Metal-Engine
//
//  Created by Zach Furman on 1/2/19.
//  Copyright © 2019 Zach Furman. All rights reserved.
//

import MetalKit

final class SphereMesh : Mesh {
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

struct SphereFace {
    var origin: float3
    var right: float3
    var up: float3
}

// A dynamically generated sphere with given LOD
final class DynamicSphere: GameObject {
    let faces: [SphereFace] = [
        SphereFace(origin: float3(-1,-1,-1), right: float3( 1, 0, 0), up: float3(0, 1, 0)),   // Front
        SphereFace(origin: float3( 1,-1,-1), right: float3( 0, 0, 1), up: float3(0, 1, 0)),   // Right
        SphereFace(origin: float3( 1,-1, 1), right: float3(-1, 0, 0), up: float3(0, 1, 0)),   // Back
        SphereFace(origin: float3(-1,-1, 1), right: float3( 0, 0,-1), up: float3(0, 1, 0)),   // Left
        SphereFace(origin: float3(-1, 1,-1), right: float3( 1, 0, 0), up: float3(0, 0, 1)),   // Top
        SphereFace(origin: float3(-1,-1, 1), right: float3( 1, 0, 0), up: float3(0, 0,-1))    // Bottom
    ]
    
    var mesh: SphereMesh
    
    override init() {
        // Swift won't let us generate the mesh before super.init(), but it also won't let us leave self.mesh
        // uninitialized before super.init(), so we give it this
        self.mesh = SphereMesh(vertices: [Vertex(position: float3(0), texel: float2(0), normals: float3(0))], indices: [0])

        super.init()
        
        updateMesh(subdivisionCount: 10)
    }
    
    // Uses spherified cube algorithm to generate sphere mesh
    private func updateMesh(subdivisionCount: Int) {
        var vertices: [Vertex] = []
        var indices: [UInt16] = []
        
        // Generate vertices
        for f in faces {
            for j in 0...subdivisionCount {
                for i in 0...subdivisionCount {
                    let offset: float3 = 2.0 * (f.right * Float(i) + f.up * Float(j))
                    let p: float3 = f.origin + (offset / Float(subdivisionCount))
                    let p2: float3 = p * p
                    let rx: Float = p.x * sqrt(1.0 - 0.5 * (p2.y + p2.z) + p2.y*p2.z/3.0)
                    let ry: Float = p.y * sqrt(1.0 - 0.5 * (p2.z + p2.x) + p2.z*p2.x/3.0)
                    let rz: Float = p.z * sqrt(1.0 - 0.5 * (p2.x + p2.y) + p2.x*p2.y/3.0)
                    
                    vertices.append(Vertex(position: float3(rx, ry, rz), texel: float2(0.8), normals: float3(rx, ry, rz)))
                }
            }
        }
        
        // Choose triangle indices
        let k = subdivisionCount + 1;
        for face in 0..<6 {
            for j in 0..<subdivisionCount {
                for i in 0..<subdivisionCount {
                    let a: Int = (face * k + j) * k + i
                    let b: Int = (face * k + j) * k + i + 1
                    let c: Int = (face * k + j + 1) * k + i
                    let d: Int = (face * k + j + 1) * k + i + 1

                    // Create quad from triangles
                    indices.append(UInt16(d))
                    indices.append(UInt16(b))
                    indices.append(UInt16(a))
                    indices.append(UInt16(a))
                    indices.append(UInt16(c))
                    indices.append(UInt16(d))
                }
            }
        }
        
        self.mesh = SphereMesh(vertices: vertices, indices: indices)
    }
}

// Tell the command encoder how to render our sphere
extension DynamicSphere: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Less))
        
        // Don't bother using the fragment shader on faces we can't see
        renderCommandEncoder.setCullMode(MTLCullMode.front)
        
        // Vertex shader
        renderCommandEncoder.setVertexBytes(&uniforms, length: Uniforms.stride, index: 1)
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        
        // Fragement shader
        renderCommandEncoder.setFragmentTexture(TextureLibrary.getTexture(.Dirt).texture, index: 0)
        
        renderCommandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: mesh.indexCount, indexType: MTLIndexType.uint16, indexBuffer: mesh.indexBuffer, indexBufferOffset: 0)
    }
}