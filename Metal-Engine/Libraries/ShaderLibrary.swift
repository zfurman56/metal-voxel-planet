//
//  ShaderLibrary.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

enum VertexShaderTypes : Int {
    case Basic
}

enum FragmentShaderTypes : Int {
    case Basic
}

class ShaderLibrary {
    public static var DefaultLibrary: MTLLibrary!
    
    private static var vertexShaders: [Shader] = []
    private static var fragmentShaders: [Shader] = []
    
    public static func Initialize() {
        DefaultLibrary = Engine.Device.makeDefaultLibrary()
        createDefaultShaders()
    }
    
    private static func createDefaultShaders() {
        vertexShaders.insert(Basic_VertexShader(), at: VertexShaderTypes.Basic.rawValue)
        fragmentShaders.insert(Basic_FragmentShader(), at: FragmentShaderTypes.Basic.rawValue)
    }
    
    public static func Vertex(_ vertexShaderType: VertexShaderTypes)->MTLFunction {
        return vertexShaders[vertexShaderType.rawValue].function
    }
    
    public static func Fragment(_ fragmentShaderType: FragmentShaderTypes)->MTLFunction {
        return fragmentShaders[fragmentShaderType.rawValue].function
    }
    
}

protocol Shader {
    var name: String { get }
    var functionName: String { get }
    var function: MTLFunction! { get }
}

public class Basic_VertexShader: Shader {
    public var name: String = "Basic Vertex Shader"
    public var functionName: String = "basic_vertex_shader"
    public var function: MTLFunction!
    init() {
        function = ShaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
    }
}

public class Basic_FragmentShader: Shader {
    public var name: String = "Basic Fragment Shader"
    public var functionName: String = "basic_fragment_shader"
    public var function: MTLFunction!
    init() {
        function = ShaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
    }
}

