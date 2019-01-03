//
//  PhysicsConformant.swift
//  Metal-Engine
//
//  Created by Zach Furman on 1/3/19.
//  Copyright © 2019 Zach Furman. All rights reserved.
//

import simd

protocol PhysicsConformant: AnyObject {
    var position: float3 {get set}
    var velocity: float3 {get set}
    var mass: Float {get}
}
extension PhysicsConformant {
    func addForce(force: float3, deltaTime: Float) {
        velocity += (force / mass) * deltaTime
    }
    
    func updatePhysics(deltaTime: Float) {
        position += velocity*deltaTime
    }
}
