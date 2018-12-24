//
//  SandboxScene.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

class SandboxScene: Scene {
    let player = Player()
    
    override func buildScene() {
        addChild(player)
    }
}
