//
//  Terrain.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/27/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

class TerrainMesh : SafeMesh {
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

enum CubeFaceType {
    case Left
    case Right
    case Top
    case Bottom
    case Back
    case Front
}

class RenderableChunk : Node {
    var uniforms: Uniforms = Uniforms()
    var mesh: TerrainMesh
    var gridPosition: Position
    
    init(position: Position) {
        self.gridPosition = position
        self.mesh = TerrainMesh(vertices: [Vertex(position: float3(0), texel: float2(0), normals: float3(0))])
        
        super.init()
        
        self.position = float3(Float(position.x*16), 0, Float(position.z*16))
        updateMesh()
    }
    
    override func update(deltaTime: Float) {
        updateUniforms()
    }
    
    public func updateMesh() {
        var vertices: [Vertex] = []
        
        var activeFaces: [[[ [CubeFaceType] ]]] = [[[[CubeFaceType]]]](repeating: [[[CubeFaceType]]](repeating: [[CubeFaceType]](repeating: [], count: 16), count: 16), count: 16)
        
        func appendFace(_ x: Int32, _ y: Int32, _ z: Int32, face: CubeFaceType) {
            if ((x>=0) && (x<16) && (y>=0) && (y<16) && (z>=0) && (z<16)) {
                activeFaces[Int(y)][Int(z)][Int(x)].append(face)
            }
        }
        
        for y: Int32 in -1..<17 {
            for z: Int32 in -1..<17 {
                for x: Int32 in -1..<17 {
                    let position = Position3D(x+(gridPosition.x*16), y, z+(gridPosition.z*16))
                    let blockType = voxelManager.grid.block(at: position)?.type
                    if (blockType == VoxelType.Air) {
                        appendFace(x+1, y, z, face: .Left)
                        appendFace(x-1, y, z, face: .Right)
                        appendFace(x, y-1, z, face: .Top)
                        appendFace(x, y+1, z, face: .Bottom)
                        appendFace(x, y, z+1, face: .Back)
                        appendFace(x, y, z-1, face: .Front)
                    }
                }
            }
        }
        
        let thisChunk = voxelManager.grid.getChunk(at: self.gridPosition)
        for y in 0..<16 {
            for z in 0..<16 {
                for x in 0..<16 {
                    let blockType = thisChunk!.blocks[y][z][x].type
                    if (blockType != VoxelType.Air) {
                        let f_position = float3(Float(x), Float(y), Float(z))
                        let texture = float2(Float((blockType.rawValue-1) % 2), Float((blockType.rawValue-1) / 2))
                        for face in activeFaces[y][z][x] {
                            vertices.append(contentsOf: RenderableChunk.cubeFace(position: f_position, texture: texture, faceType: face))
                        }
                    }
                }
            }
        }
        
        self.mesh = TerrainMesh(vertices: vertices)
    }
    
    private static func cubeFace(position: float3, texture: float2, faceType: CubeFaceType)->[Vertex] {
        let face: [Vertex]
        let texSize: Float = 0.5
        switch (faceType) {
        case .Left:
            face = [
                Vertex(position: float3(-0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(-1, 0, 0)),
                Vertex(position: float3(-0.5,-0.5, 0.5)+position, texel: float2(0, 0)+texture, normals: float3(-1, 0, 0)),
                Vertex(position: float3(-0.5, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(-1, 0, 0)),
                Vertex(position: float3(-0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(-1, 0, 0)),
                Vertex(position: float3(-0.5, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(-1, 0, 0)),
                Vertex(position: float3(-0.5, 0.5,-0.5)+position, texel: float2(texSize, texSize)+texture, normals: float3(-1, 0, 0))
            ]
        case .Right:
            face = [
                Vertex(position: float3( 0.5, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(1, 0, 0)),
                Vertex(position: float3( 0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(1, 0, 0)),
                Vertex(position: float3( 0.5, 0.5,-0.5)+position, texel: float2(texSize, texSize)+texture, normals: float3(1, 0, 0)),
                Vertex(position: float3( 0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(1, 0, 0)),
                Vertex(position: float3( 0.5, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(1, 0, 0)),
                Vertex(position: float3( 0.5,-0.5, 0.5)+position, texel: float2(0, 0)+texture, normals: float3(1, 0, 0))
            ]
        case .Top:
            face = [
                Vertex(position: float3( 0.5, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(0, 1, 0)),
                Vertex(position: float3( 0.5, 0.5,-0.5)+position, texel: float2(texSize, texSize)+texture, normals: float3(0, 1, 0)),
                Vertex(position: float3(-0.5, 0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(0, 1, 0)),
                Vertex(position: float3( 0.5, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(0, 1, 0)),
                Vertex(position: float3(-0.5, 0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(0, 1, 0)),
                Vertex(position: float3(-0.5, 0.5, 0.5)+position, texel: float2(0, 0)+texture, normals: float3(0, 1, 0))
            ]
            
        case .Bottom:
            face = [
                Vertex(position: float3( 0.5,-0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(0, -1, 0)),
                Vertex(position: float3(-0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(0, -1, 0)),
                Vertex(position: float3( 0.5,-0.5,-0.5)+position, texel: float2(texSize, texSize)+texture, normals: float3(0, -1, 0)),
                Vertex(position: float3( 0.5,-0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(0, -1, 0)),
                Vertex(position: float3(-0.5,-0.5, 0.5)+position, texel: float2(0, 0)+texture, normals: float3(0, -1, 0)),
                Vertex(position: float3(-0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(0, -1, 0))
            ]
        case .Back:
            face = [
                Vertex(position: float3( 0.5, 0.5,-0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(0, 0, -1)),
                Vertex(position: float3(-0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(0, 0, -1)),
                Vertex(position: float3(-0.5, 0.5,-0.5)+position, texel: float2(0, 0)+texture, normals: float3(0, 0, -1)),
                Vertex(position: float3( 0.5, 0.5,-0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(0, 0, -1)),
                Vertex(position: float3( 0.5,-0.5,-0.5)+position, texel: float2(texSize, texSize)+texture, normals: float3(0, 0, -1)),
                Vertex(position: float3(-0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(0, 0, -1))
            ]
        case .Front:
            face = [
                Vertex(position: float3(-0.5, 0.5, 0.5)+position, texel: float2(0, 0), normals: float3(0, 0, 1)),
                Vertex(position: float3(-0.5,-0.5, 0.5)+position, texel: float2(0, texSize), normals: float3(0, 0, 1)),
                Vertex(position: float3( 0.5,-0.5, 0.5)+position, texel: float2(texSize, texSize), normals: float3(0, 0, 1)),
                Vertex(position: float3( 0.5, 0.5, 0.5)+position, texel: float2(texSize, 0), normals: float3(0, 0, 1)),
                Vertex(position: float3(-0.5, 0.5, 0.5)+position, texel: float2(0, 0), normals: float3(0, 0, 1)),
                Vertex(position: float3( 0.5,-0.5, 0.5)+position, texel: float2(texSize, texSize), normals: float3(0, 0, 1))
            ]
        }
        return face
    }
    
    private func updateUniforms() {
        uniforms.modelViewProjectionMatrix = SceneManager.currentScene.cameraManager.currentCamera.projectionMatrix * SceneManager.currentScene.cameraManager.currentCamera.viewMatrix * self.modelMatrix
        uniforms.normalMatrix = self.normalMatrix
    }
    
    
}

extension RenderableChunk: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        if (mesh.vertexBuffer != nil) {
            renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
            renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Less))
            renderCommandEncoder.setCullMode(MTLCullMode.front)
            
            // Vertex shader
            renderCommandEncoder.setVertexBytes(&uniforms, length: Uniforms.stride, index: 1)
            renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
            
            // Fragement shader
            renderCommandEncoder.setFragmentTexture(TextureLibrary.getTexture(.Dirt).texture, index: 0)
            
            renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mesh.vertexCount)
        }
    }
}

class VoxelTerrain {
    var chunks: [RenderableChunk]
    
    init() {
        self.chunks = []
    }
}
