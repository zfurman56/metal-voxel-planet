//
//  Engine.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

final class Engine {
    public static var Device: MTLDevice!
    public static var CommandQueue: MTLCommandQueue!
    
    public static func Ignite(device: MTLDevice) {
        self.Device = device
        self.CommandQueue = device.makeCommandQueue()
        
        // Initialize all libraries
        ShaderLibrary.Initialize()
        VertexDescriptorLibrary.Intialize()
        DepthStencilStateLibrary.Intitialize()
        RenderPipelineDescriptorLibrary.Initialize()
        RenderPipelineStateLibrary.Initialize()
        MeshLibrary.Initialize()
        TextureLibrary.Initialize(device: device)
        TerrainGenerationLibrary.Initialize(seed: Preferences.WorldSeed)
        SceneManager.Initialize(Preferences.StartingScene)
    }
}
