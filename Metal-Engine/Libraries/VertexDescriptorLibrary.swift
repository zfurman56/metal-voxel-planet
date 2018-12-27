//
//  VertexDescriptorLibrary.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

enum VertexDescriptorTypes {
    case Basic
}

class VertexDescriptorLibrary {
    
    private static var vertexDescriptors: [VertexDescriptorTypes: VertexDescriptor] = [:]
    
    public static func Intialize() {
        createDefaultVertexDescriptors()
    }
    
    private static func createDefaultVertexDescriptors() {
        vertexDescriptors.updateValue(Basic_VertexDescriptor(), forKey: .Basic)
    }
    
    public static func Descriptor(_ vertexDescriptorType: VertexDescriptorTypes)->MTLVertexDescriptor{
        return vertexDescriptors[vertexDescriptorType]!.vertexDescriptor
    }
    
}

protocol VertexDescriptor {
    var name: String { get }
    var vertexDescriptor: MTLVertexDescriptor! { get }
}


public struct Basic_VertexDescriptor: VertexDescriptor{
    var name: String = "Basic Vertex Descriptor"
    
    var vertexDescriptor: MTLVertexDescriptor!
    init() {
        vertexDescriptor = MTLVertexDescriptor()
        
        //Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = Vertex.memOffset(of: \Vertex.position)
        
        //Color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = Vertex.memOffset(of: \Vertex.color)
        
        // Texel
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].offset = Vertex.memOffset(of: \Vertex.texel)
        
        // Normals
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].bufferIndex = 0
        vertexDescriptor.attributes[3].offset = Vertex.memOffset(of: \Vertex.normals)
        
        vertexDescriptor.layouts[0].stride = Vertex.stride
    }
}
