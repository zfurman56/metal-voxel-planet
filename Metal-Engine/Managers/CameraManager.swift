//
//  CameraManager.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//


// Global singleton, manages cameras
class CameraManager {
    private static var _cameras: [CameraTypes: Camera] = [:]
    public static var currentCamera: Camera!
    
    public static func registerCamera(camera: Camera) {
        self._cameras.updateValue(camera, forKey: camera.cameraType)
    }
    
    public static func setCamera(_ cameraType: CameraTypes) {
        self.currentCamera = _cameras[cameraType]
    }
    
    internal static func update(deltaTime: Float) {
        for camera in _cameras.values {
            camera.update(deltaTime: deltaTime)
        }
    }
}
