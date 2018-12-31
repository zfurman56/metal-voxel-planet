//
//  RenderPipelineStateLibrary.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//


import MetalKit

enum RenderPipelineStateTypes : Int {
    case Basic
}

final class RenderPipelineStateLibrary {
    
    private static var renderPipelineStates: [RenderPipelineState] = []
    
    public static func Initialize(){
        createDefaultRenderPipelineStates()
    }
    
    private static func createDefaultRenderPipelineStates(){
        renderPipelineStates.insert(Basic_RenderPipelineState(), at: RenderPipelineStateTypes.Basic.rawValue)
    }
    
    public static func PipelineState(_ renderPipelineStateType: RenderPipelineStateTypes)->MTLRenderPipelineState{
        return (renderPipelineStates[renderPipelineStateType.rawValue].renderPipelineState)!
    }
    
}

protocol RenderPipelineState: AnyObject {
    var name: String { get }
    var renderPipelineState: MTLRenderPipelineState! { get }
}

public class Basic_RenderPipelineState: RenderPipelineState {
    var name: String = "Basic Render Pipeline State"
    var renderPipelineState: MTLRenderPipelineState!
    init() {
        do{
            renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: RenderPipelineDescriptorLibrary.Descriptor(.Basic))
        }catch let error as NSError {
            print("ERROR::CREATE::RENDER_PIPELINE_STATE::__\(name)__::\(error)")
        }
    }
}
