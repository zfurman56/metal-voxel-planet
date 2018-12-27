//
//  SceneManager.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

enum SceneTypes{
    case Sandbox
}

// Global singleton, manages scene selection and scene updates
class SceneManager {
    
    public static var currentScene: Scene!
    
    public static func Initialize(_ sceneType: SceneTypes) {
        SetScene(sceneType)
    }
    
    public static func SetScene(_ sceneType: SceneTypes) {
        switch sceneType {
        case .Sandbox:
            currentScene = SandboxScene()
        }
    }
    
    public static func TickScene(renderCommandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        currentScene.updateCameras(deltaTime: deltaTime)
        currentScene.update(deltaTime: deltaTime)
        currentScene.render(renderCommandEncoder: renderCommandEncoder)
    }
        
}


