//
//  RenderPipelineDescriptorLibrary.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

enum RenderPipelineDescriptorTypes : Int {
    case Basic
}

final class RenderPipelineDescriptorLibrary {
    private static var renderPipelineDescriptors: [RenderPipelineDescriptor] = []

    public static func Initialize() {
        createDefaultRenderPipelineDescriptors()
    }

    private static func createDefaultRenderPipelineDescriptors() {
        renderPipelineDescriptors.insert(Basic_RenderPipelineDescriptor(), at: RenderPipelineDescriptorTypes.Basic.rawValue)
    }

    public static func Descriptor(_ renderPipelineDescriptorType: RenderPipelineDescriptorTypes)->MTLRenderPipelineDescriptor {
        return renderPipelineDescriptors[renderPipelineDescriptorType.rawValue].renderPipelineDescriptor
    }
}

protocol RenderPipelineDescriptor: AnyObject {
    var name: String { get }
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor! { get }
}

public class Basic_RenderPipelineDescriptor: RenderPipelineDescriptor {
    var name: String = "Basic Render Pipeline Descriptor"
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor!
    init() {
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()

        renderPipelineDescriptor.colorAttachments[0].pixelFormat = Preferences.MainPixelFormat
        renderPipelineDescriptor.depthAttachmentPixelFormat = Preferences.MainDepthPixelFormat
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.Vertex(.Basic)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.Fragment(.Basic)
        renderPipelineDescriptor.vertexDescriptor = VertexDescriptorLibrary.Descriptor(.Basic)
    }
}
