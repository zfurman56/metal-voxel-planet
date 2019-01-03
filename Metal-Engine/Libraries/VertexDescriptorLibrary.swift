//
//  VertexDescriptorLibrary.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

enum VertexDescriptorTypes : Int {
    case Basic
}

// Global singleton, tells the GPU what attributes to expect from input data
final class VertexDescriptorLibrary {
    
    private static var vertexDescriptors: [VertexDescriptor] = []
    
    public static func Intialize() {
        createDefaultVertexDescriptors()
    }
    
    private static func createDefaultVertexDescriptors() {
        vertexDescriptors.insert(Basic_VertexDescriptor(), at: VertexDescriptorTypes.Basic.rawValue)
    }
    
    public static func Descriptor(_ vertexDescriptorType: VertexDescriptorTypes)->MTLVertexDescriptor{
        return vertexDescriptors[vertexDescriptorType.rawValue].vertexDescriptor
    }
    
}

protocol VertexDescriptor: AnyObject {
    var name: String { get }
    var vertexDescriptor: MTLVertexDescriptor! { get }
}


public class Basic_VertexDescriptor: VertexDescriptor{
    var name: String = "Basic Vertex Descriptor"
    
    var vertexDescriptor: MTLVertexDescriptor!
    init() {
        vertexDescriptor = MTLVertexDescriptor()
        
        //Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = Vertex.memOffset(of: \Vertex.position)
        
        // Texel
        vertexDescriptor.attributes[1].format = .float2
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = Vertex.memOffset(of: \Vertex.texel)
        
        // Normals
        vertexDescriptor.attributes[2].format = .float3
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].offset = Vertex.memOffset(of: \Vertex.normals)
        
        vertexDescriptor.layouts[0].stride = Vertex.stride
    }
}
