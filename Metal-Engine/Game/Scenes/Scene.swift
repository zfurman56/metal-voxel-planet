//
//  Scene.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

// Base class for all scenes
class Scene : Node {
    
    var cameraManager = CameraManager()
    var sceneConstants = SceneConstants()
    var light: Light! // override this!
    
    override init() {
        super.init()
        buildScene()
    }
    
    func buildScene () {
    }
    
    func addCamera(_ camera: Camera, isCurrentCamera: Bool = true) {
        cameraManager.registerCamera(camera: camera)
        if (isCurrentCamera) {
            cameraManager.setCamera(camera.cameraType)
        }
    }
    
    private func updateSceneConstants() {
        sceneConstants.viewMatrix = cameraManager.currentCamera.viewMatrix
        sceneConstants.projectionMatrix = cameraManager.currentCamera.projectionMatrix
    }
    
    public func updateCameras(deltaTime: Float) {
        cameraManager.update(deltaTime: deltaTime)
    }
    
    override func update(deltaTime: Float) {
        cameraManager.currentCamera.update(deltaTime: deltaTime)
        updateSceneConstants()

        super.update(deltaTime: deltaTime)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setFragmentBytes(&light, length: Light.stride, index: 3)
        super.render(renderCommandEncoder: renderCommandEncoder)
    }
}
