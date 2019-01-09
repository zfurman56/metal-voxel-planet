//
//  FarTerrain.swift
//  Metal-Engine
//
//  Created by Zach Furman on 1/7/19.
//  Copyright © 2019 Zach Furman. All rights reserved.
//

import MetalKit

// Renders approximation of terrain that is too far away to be loaded as voxels
final class FarTerrain: GameObject {
    var mesh: FixedMesh
    
    override init() {
        // Swift won't let us generate the mesh before super.init(), but it also won't let us leave self.mesh
        // uninitialized before super.init(), so we give it this
        self.mesh = FixedMesh(vertices: [Vertex(position: float3(0), texel: float2(0), normals: float3(0))])
        
        super.init()
        
        updateMesh(center: Position(0.0, 0.0))
    }
    
    public func updateMesh(center: Position) {
        var vertices: [Vertex] = []
        
        /*
         $ represents loaded voxels
         # represents loaded far terrain
         
         (Camera is at center)
         
         # # # # # # # # #
         # # # # # # # # #
         # # # # # # # # #
         # # # $ $ $ # # #
         # # # $ $ $ # # #
         # # # $ $ $ # # #
         # # # # # # # # #
         # # # # # # # # #
         # # # # # # # # #
               <->   chunkDist
         <------->   farDist
         
         In this example, chunkDist = 1 and farDist = 4
        */
        let chunkDist = Preferences.ChunkDistance
        let farDist = Preferences.FarDistance
        
        let terrain = TerrainGenerationLibrary.getTerrain(.Basic)
        
        let texSize: Float = 0.5
        let patchSize: Int = 16
        for x in -farDist...farDist  {
            for z in -farDist...farDist  {
                if (abs(x*patchSize) <= chunkDist*16) && (abs(z*patchSize) <= chunkDist*16) {
                    continue
                }
                
                let gridPosition = Position(Int32((patchSize*x)+(16*Int(center.x))), Int32((patchSize*z)+(16*Int(center.z))))
                let position = float3(Float(gridPosition.x), 0, Float(gridPosition.z))
                
                let heightA = terrain.getApproxHeight(position: gridPosition)
                let heightB = terrain.getApproxHeight(position: Position(gridPosition.x, gridPosition.z+Int32(patchSize)))
                let heightC = terrain.getApproxHeight(position: Position(gridPosition.x+Int32(patchSize), gridPosition.z))
                let heightD = terrain.getApproxHeight(position: Position(gridPosition.x+Int32(patchSize), gridPosition.z+Int32(patchSize)))
                
                let normal1 = simd_normalize(simd_cross(float3(0,heightB-heightA,Float(-patchSize)), float3(Float(-patchSize),heightD-heightA,Float(-patchSize))))
                let normal2 = simd_normalize(simd_cross(float3(Float(-patchSize),heightD-heightA,Float(-patchSize)), float3(Float(-patchSize),heightC-heightA,0)))
                
                vertices.append(Vertex(position: position+float3(0,heightA,0), texel: float2(0, 0), normals: normal1))
                vertices.append(Vertex(position: position+float3(0,heightB,Float(patchSize)), texel: float2(0, texSize), normals: normal1))
                vertices.append(Vertex(position: position+float3(Float(patchSize),heightD,Float(patchSize)), texel: float2(texSize, texSize), normals: normal1))
                
                vertices.append(Vertex(position: position+float3(Float(patchSize),heightD,Float(patchSize)), texel: float2(texSize, texSize), normals: normal2))
                vertices.append(Vertex(position: position+float3(Float(patchSize),heightC,0), texel: float2(texSize, 0), normals: normal2))
                vertices.append(Vertex(position: position+float3(0,heightA,0), texel: float2(0, 0), normals: normal2))
            }
        }

        self.mesh = FixedMesh(vertices: vertices)
    }
}

// Tell the command encoder how to render our sphere
extension FarTerrain: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Surface))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Less))
        
        // Don't bother using the fragment shader on faces we can't see
        renderCommandEncoder.setCullMode(MTLCullMode.front)
        
        // Vertex shader
        renderCommandEncoder.setVertexBytes(&uniforms, length: Uniforms.stride, index: 1)
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        
        // Fragement shader
        renderCommandEncoder.setFragmentTexture(TextureLibrary.getTexture(.Dirt).texture, index: 0)
        
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mesh.vertexCount)    }
}
