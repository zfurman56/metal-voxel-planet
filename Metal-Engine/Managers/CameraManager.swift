//
//  CameraManager.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import AppKit

// Global singleton, manages cameras
class CameraManager {
    public static var cameras: [String: Camera] = [:]
    public static var currentCamera: Camera!
    public static var cursorLocked: Bool = false
    
    public static func registerCamera(camera: Camera, cameraID: String) {
        self.cameras.updateValue(camera, forKey: cameraID)
    }
    
    public static func setCamera(_ cameraID: String) {
        self.currentCamera = cameras[cameraID]
    }
    
    // Used to (un)hide and (un)lock the cursor when the window is selected
    public static func setCursorLock(to isLocked: Bool) {
        cursorLocked = isLocked
        CGAssociateMouseAndMouseCursorPosition(boolean_t(exactly: (isLocked ? 0 : 1))!)
        if (isLocked) {
            NSCursor.hide()
        } else {
            NSCursor.unhide()
        }
    }
    
    internal static func update(deltaTime: Float) {
        currentCamera.update(deltaTime: deltaTime)
    }
}
