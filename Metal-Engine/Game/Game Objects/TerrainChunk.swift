//
//  Terrain.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/27/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

class TerrainMesh : Mesh {
    var vertexBuffer: MTLBuffer!
    var vertexCount: Int!
    
    init(vertices: [Vertex]) {
        self.vertexCount = vertices.count
        self.vertexBuffer = Engine.Device.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: [])
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

class TerrainChunk : Node {
    var chunk: Chunk
    var uniforms: Uniforms = Uniforms()
    var mesh: TerrainMesh
    
    init(position: Position) {
        self.chunk = Chunk(position: position)
        self.mesh = TerrainMesh(vertices: [Vertex(position: float3(0), texel: float2(0), normals: float3(0))])
        
        super.init()
        
        updateMesh()
    }
    
    override func update(deltaTime: Float) {
        updateUniforms()
    }
    
    public func updateMesh() {
        var vertices: [Vertex] = []
        
        for y in 0..<16 {
            for z in 0..<16 {
                for x in 0..<16 {
                    let blockType = self.chunk.blocks[y][z][x].type
                    if (blockType != VoxelType.Air) {
                        let position = float3(Float(x), Float(y), Float(z))
                        let texture = float2(Float((blockType.rawValue-1) % 2), Float((blockType.rawValue-1) / 2))
                        
                        if ((self.chunk.blocks[safe: y]?[safe: z]?[safe: x-1]?.type ?? VoxelType.Air) == VoxelType.Air) {
                            vertices.append(contentsOf: TerrainChunk.cubeFace(position: position, texture: texture, faceType: .Left))
                        }
                        if ((self.chunk.blocks[safe: y]?[safe: z]?[safe: x+1]?.type ?? VoxelType.Air) == VoxelType.Air) {
                            vertices.append(contentsOf: TerrainChunk.cubeFace(position: position, texture: texture, faceType: .Right))
                        }
                        if ((self.chunk.blocks[safe: y+1]?[safe: z]?[safe: x]?.type ?? VoxelType.Air) == VoxelType.Air) {
                            vertices.append(contentsOf: TerrainChunk.cubeFace(position: position, texture: texture, faceType: .Top))
                        }
                        if ((self.chunk.blocks[safe: y-1]?[safe: z]?[safe: x]?.type ?? VoxelType.Air) == VoxelType.Air) {
                            vertices.append(contentsOf: TerrainChunk.cubeFace(position: position, texture: texture, faceType: .Bottom))
                        }
                        if ((self.chunk.blocks[safe: y]?[safe: z-1]?[safe: x]?.type ?? VoxelType.Air) == VoxelType.Air) {
                            vertices.append(contentsOf: TerrainChunk.cubeFace(position: position, texture: texture, faceType: .Back))
                        }
                        if ((self.chunk.blocks[safe: y]?[safe: z+1]?[safe: x]?.type ?? VoxelType.Air) == VoxelType.Air) {
                            vertices.append(contentsOf: TerrainChunk.cubeFace(position: position, texture: texture, faceType: .Front))
                        }
//                        if ((self.chunk.blocks[safe: y+1]?[safe: z]?[safe: x]?.type != VoxelType.Dirt) ||
//                            (self.chunk.blocks[safe: y]?[safe: z+1]?[safe: x]?.type != VoxelType.Dirt) ||
//                            (self.chunk.blocks[safe: y]?[safe: z]?[safe: x+1]?.type != VoxelType.Dirt) ||
//                            (self.chunk.blocks[safe: y-1]?[safe: z]?[safe: x]?.type != VoxelType.Dirt) ||
//                            (self.chunk.blocks[safe: y]?[safe: z-1]?[safe: x]?.type != VoxelType.Dirt) ||
//                            (self.chunk.blocks[safe: y]?[safe: z]?[safe: x-1]?.type != VoxelType.Dirt)) {
//                        vertices.append(contentsOf: TerrainChunk.generateCube(position: float3(Float(x), Float(y), Float(z)), blockType: blockType))
//                        }
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

//        let nhalved = normal/2
//        if (normal.x != 0) {
//            face = [
//                Vertex(position: nhalved+float3(0,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: normal),
//                Vertex(position: nhalved+float3(0,-0.5, 0.5)+position, texel: float2(0, 0)+texture, normals: normal),
//                Vertex(position: nhalved+float3(0, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: normal),
//                Vertex(position: nhalved+float3(0, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: normal),
//                Vertex(position: nhalved+float3(0,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: normal),
//                Vertex(position: nhalved+float3(0, 0.5,-0.5)+position, texel: float2(texSize, texSize)+texture, normals: normal),
//            ]
//        } else if (normal.y != 0) {
//            face = [
//                Vertex(position: nhalved+float3(-0.5,0,-0.5)+position, texel: float2(0, texSize)+texture, normals: normal),
//                Vertex(position: nhalved+float3(-0.5,0, 0.5)+position, texel: float2(0, 0)+texture, normals: normal),
//                Vertex(position: nhalved+float3( 0.5,0, 0.5)+position, texel: float2(texSize, 0)+texture, normals: normal),
//                Vertex(position: nhalved+float3( 0.5,0, 0.5)+position, texel: float2(texSize, 0)+texture, normals: normal),
//                Vertex(position: nhalved+float3(-0.5,0,-0.5)+position, texel: float2(0, texSize)+texture, normals: normal),
//                Vertex(position: nhalved+float3( 0.5,0,-0.5)+position, texel: float2(texSize, texSize)+texture, normals: normal),
//            ]
//        } else {
//            face = [
//                Vertex(position: nhalved+float3(-0.5,0,-0.5)+position, texel: float2(0, texSize)+texture, normals: normal),
//                Vertex(position: nhalved+float3(-0.5,0, 0.5)+position, texel: float2(0, 0)+texture, normals: normal),
//                Vertex(position: nhalved+float3( 0.5,0, 0.5)+position, texel: float2(texSize, 0)+texture, normals: normal),
//                Vertex(position: nhalved+float3( 0.5,0, 0.5)+position, texel: float2(texSize, 0)+texture, normals: normal),
//                Vertex(position: nhalved+float3(-0.5,0,-0.5)+position, texel: float2(0, texSize)+texture, normals: normal),
//                Vertex(position: nhalved+float3( 0.5,0,-0.5)+position, texel: float2(texSize, texSize)+texture, normals: normal),
//            ]
//        }
    
//    private static func generateCube(position: float3, blockType: VoxelType)->[Vertex] {
//        let texture = float2(Float((blockType.rawValue-1) % 2), Float((blockType.rawValue-1) / 2))
//        let cube: [Vertex] = [
//            // LEFT
//            Vertex(position: float3(-0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(-1, 0, 0)),
//            Vertex(position: float3(-0.5,-0.5, 0.5)+position, texel: float2(0, 0)+texture, normals: float3(-1, 0, 0)),
//            Vertex(position: float3(-0.5, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(-1, 0, 0)),
//            Vertex(position: float3(-0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(-1, 0, 0)),
//            Vertex(position: float3(-0.5, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(-1, 0, 0)),
//            Vertex(position: float3(-0.5, 0.5,-0.5)+position, texel: float2(texSize, texSize)+texture, normals: float3(-1, 0, 0)),
//            
//            //RIGHT
//            Vertex(position: float3( 0.5, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(1, 0, 0)),
//            Vertex(position: float3( 0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(1, 0, 0)),
//            Vertex(position: float3( 0.5, 0.5,-0.5)+position, texel: float2(texSize, texSize)+texture, normals: float3(1, 0, 0)),
//            Vertex(position: float3( 0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(1, 0, 0)),
//            Vertex(position: float3( 0.5, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(1, 0, 0)),
//            Vertex(position: float3( 0.5,-0.5, 0.5)+position, texel: float2(0, 0)+texture, normals: float3(1, 0, 0)),
//            
//            //TOP
//            Vertex(position: float3( 0.5, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(0, 1, 0)),
//            Vertex(position: float3( 0.5, 0.5,-0.5)+position, texel: float2(texSize, texSize)+texture, normals: float3(0, 1, 0)),
//            Vertex(position: float3(-0.5, 0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(0, 1, 0)),
//            Vertex(position: float3( 0.5, 0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(0, 1, 0)),
//            Vertex(position: float3(-0.5, 0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(0, 1, 0)),
//            Vertex(position: float3(-0.5, 0.5, 0.5)+position, texel: float2(0, 0)+texture, normals: float3(0, 1, 0)),
//            
//            //BOTTOM
//            Vertex(position: float3( 0.5,-0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(0, -1, 0)),
//            Vertex(position: float3(-0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(0, -1, 0)),
//            Vertex(position: float3( 0.5,-0.5,-0.5)+position, texel: float2(texSize, texSize)+texture, normals: float3(0, -1, 0)),
//            Vertex(position: float3( 0.5,-0.5, 0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(0, -1, 0)),
//            Vertex(position: float3(-0.5,-0.5, 0.5)+position, texel: float2(0, 0)+texture, normals: float3(0, -1, 0)),
//            Vertex(position: float3(-0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(0, -1, 0)),
//            
//            //BACK
//            Vertex(position: float3( 0.5, 0.5,-0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(0, 0, -1)),
//            Vertex(position: float3(-0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(0, 0, -1)),
//            Vertex(position: float3(-0.5, 0.5,-0.5)+position, texel: float2(0, 0)+texture, normals: float3(0, 0, -1)),
//            Vertex(position: float3( 0.5, 0.5,-0.5)+position, texel: float2(texSize, 0)+texture, normals: float3(0, 0, -1)),
//            Vertex(position: float3( 0.5,-0.5,-0.5)+position, texel: float2(texSize, texSize)+texture, normals: float3(0, 0, -1)),
//            Vertex(position: float3(-0.5,-0.5,-0.5)+position, texel: float2(0, texSize)+texture, normals: float3(0, 0, -1)),
//            
//            //FRONT
//            Vertex(position: float3(-0.5, 0.5, 0.5)+position, texel: float2(0, 0), normals: float3(0, 0, 1)),
//            Vertex(position: float3(-0.5,-0.5, 0.5)+position, texel: float2(0, texSize), normals: float3(0, 0, 1)),
//            Vertex(position: float3( 0.5,-0.5, 0.5)+position, texel: float2(texSize, texSize), normals: float3(0, 0, 1)),
//            Vertex(position: float3( 0.5, 0.5, 0.5)+position, texel: float2(texSize, 0), normals: float3(0, 0, 1)),
//            Vertex(position: float3(-0.5, 0.5, 0.5)+position, texel: float2(0, 0), normals: float3(0, 0, 1)),
//            Vertex(position: float3( 0.5,-0.5, 0.5)+position, texel: float2(texSize, texSize), normals: float3(0, 0, 1))
//        ]
//        return cube
//    }
    
    private func updateUniforms() {
        uniforms.modelViewProjectionMatrix = SceneManager.currentScene.cameraManager.currentCamera.projectionMatrix * SceneManager.currentScene.cameraManager.currentCamera.viewMatrix * self.modelMatrix
        uniforms.normalMatrix = self.normalMatrix
    }
    
    
}

extension TerrainChunk: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
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

class VoxelGrid {
    var terrain: [TerrainChunk] = [TerrainChunk(position: Position(x:0, y:0))]
}
