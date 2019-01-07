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
    
    var sceneConstants = SceneConstants()
    var light: Light! // override this!
    
    override init() {
        super.init()
        buildScene()
    }
    
    func buildScene () {
    }
    
    func addCamera(_ camera: Camera, _ cameraID: String, isCurrentCamera: Bool = true) {
        CameraManager.registerCamera(camera: camera, cameraID: cameraID)
        if (isCurrentCamera) {
            CameraManager.setCamera(cameraID)
        }
    }
    
    private func updateSceneConstants() {
        sceneConstants.viewMatrix = CameraManager.currentCamera.viewMatrix
        sceneConstants.projectionMatrix = CameraManager.currentCamera.projectionMatrix
    }
    
    public func updateCameras(deltaTime: Float) {
        CameraManager.update(deltaTime: deltaTime)
    }
    
    override func update(deltaTime: Float) {
        CameraManager.currentCamera.update(deltaTime: deltaTime)
        updateSceneConstants()

        super.update(deltaTime: deltaTime)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setFragmentBytes(&light, length: Light.stride, index: 3)
        super.render(renderCommandEncoder: renderCommandEncoder)
    }
}
