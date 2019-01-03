//
//  CameraManager.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//


// Every scene has a camera manager
// Holds the current camera for each scene
class CameraManager {
    private var _cameras: [CameraTypes: Camera] = [:]
    public var currentCamera: Camera!
    
    public func registerCamera(camera: Camera) {
        self._cameras.updateValue(camera, forKey: camera.cameraType)
    }
    
    public func setCamera(_ cameraType: CameraTypes) {
        self.currentCamera = _cameras[cameraType]
    }
    
    internal func update(deltaTime: Float) {
        for camera in _cameras.values {
            camera.update(deltaTime: deltaTime)
        }
    }
}
