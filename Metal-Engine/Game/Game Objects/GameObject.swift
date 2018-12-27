//
//  GameObject.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

class GameObject : Node {
    
    var modelConstants = ModelConstants()
    var uniforms = Uniforms()
    var mesh: Mesh!
    
    init(meshType: PrefabTypes) {
        mesh = MeshLibrary.Mesh(meshType)
    }
    
    var time: Float = 0
    override func update(deltaTime: Float) {
        time += deltaTime
        updateModelConstants()
    }
    
    private func updateModelConstants() {
        modelConstants.modelMatrix = self.modelMatrix
    }

}

// Tell the command encoder how to render GameObjects
extension GameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Less))
        
        // Vertex shader
        let modelViewMatrix = SceneManager.currentScene.cameraManager.currentCamera.viewMatrix * self.modelConstants.modelMatrix
        let normalMatrix: float3x3 = float3x3(float3(Array((self.modelConstants.modelMatrix.columns.0)[0..<3])), float3(Array((self.modelConstants.modelMatrix.columns.1)[0..<3])), float3(Array((self.modelConstants.modelMatrix.columns.2)[0..<3])))
        uniforms.normalMatrix = normalMatrix.inverse.transpose
        uniforms.modelViewProjectionMatrix =  SceneManager.currentScene.cameraManager.currentCamera.projectionMatrix * modelViewMatrix
        renderCommandEncoder.setVertexBytes(&uniforms, length: Uniforms.stride, index: 1)
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        
        // Fragement shader
        renderCommandEncoder.setFragmentTexture(TextureLibrary.getTexture(.Dirt).texture, index: 0)
        
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mesh.vertexCount)
    }
}
