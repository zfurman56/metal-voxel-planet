//
//  Terrain.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/27/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

enum CubeFaceType: UInt8, CaseIterable {
    case Left
    case Right
    case Top
    case Bottom
    case Back
    case Front
}

struct FaceBitPack {
    var byte: UInt8 = 0
    
    func get(face: CubeFaceType)->Bool {
        return (byte & (0x1<<face.rawValue)) != 0
    }
}

final class RenderableChunk : GameObject {
    var mesh: SafeFixedMesh = SafeFixedMesh(vertices: [])
    var gridPosition: Position
    
    init(position: Position) {
        self.gridPosition = position
        
        super.init()
        
        self.position = float3(Float(position.x*16), 0, Float(position.z*16))
        updateMesh()
    }
    
    // In order to save GPU time, we should only render the block faces that
    // are visible; i.e. faces that border air blocks
    public func updateMesh() {
        var vertices: [Vertex] = []
        
        // Used to store which faces should be rendered
        var activeFaces: ContiguousArray<ContiguousArray<ContiguousArray<FaceBitPack>>> = ContiguousArray<ContiguousArray<ContiguousArray<FaceBitPack>>>(repeating: ContiguousArray<ContiguousArray<FaceBitPack>>(repeating: ContiguousArray<FaceBitPack>(repeating: FaceBitPack(), count: 16), count: 16), count: 16)
        
        // Checks whether the given face is within the chunk, and updates activeFaces if it is
        func appendFace(_ x: Int32, _ y: Int32, _ z: Int32, face: CubeFaceType) {
            if ((x>=0) && (x<16) && (y>=0) && (y<16) && (z>=0) && (z<16)) {
                activeFaces[Int(y)][Int(z)][Int(x)].byte |= (0x1<<face.rawValue)
            }
        }
        
        // Loop through all possible air blocks that could affect this chunk
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
        
        // Loop through all blocks in the chunk and add faces to the mesh
        let thisChunk = voxelManager.grid.getChunk(at: self.gridPosition)
        for y in 0..<16 {
            for z in 0..<16 {
                for x in 0..<16 {
                    let blockType = thisChunk!.blocks[y][z][x].type
                    if (blockType != VoxelType.Air) {
                        let f_position = float3(Float(x), Float(y), Float(z))
                        let texture = float2(Float((blockType.rawValue-1) % 2), Float((blockType.rawValue-1) / 2))
                        for face in CubeFaceType.allCases {
                            if (activeFaces[y][z][x].get(face: face)) {
                                vertices.append(contentsOf: RenderableChunk.cubeFace(position: f_position, texture: texture, faceType: face))
                            }
                        }
                    }
                }
            }
        }
        
        self.mesh = SafeFixedMesh(vertices: vertices)
    }
    
    // Get the vertices of a cube face given the face type, position, and texture
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
}

// Tell the command encoder how to render chunks
extension RenderableChunk: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        if (mesh.vertexBuffer != nil) {
            renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Surface))
            renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Less))

            // Don't bother using the fragment shader on faces we can't see
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
