//
//  Player.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

class Player : GameObject {
    init() {
        super.init(meshType: .Triangle_Custom)
    }
    
    override func update(deltaTime: Float) {
        if (Mouse.IsMouseButtonPressed(button: .left)) {
            self.scale = float3((0.05*cos(2*time)) + 0.08)
        }

        self.rotation.z = -atan2(Mouse.GetMouseViewportPosition().x - position.x, Mouse.GetMouseViewportPosition().y - position.y)
        
        super.update(deltaTime: deltaTime)
    }
}
