//
//  GameView.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/23/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

class GameView: MTKView {
    
    var renderer: Renderer!
    required init(coder: NSCoder) {
        super.init(coder: coder)

        self.device = MTLCreateSystemDefaultDevice()
        
        Engine.Ignite(device: device!)
        
        self.clearColor = Preferences.ClearColor
        
        self.colorPixelFormat = Preferences.MainPixelFormat
        
        self.renderer = Renderer()
        
        self.delegate = self.renderer
    }
}
