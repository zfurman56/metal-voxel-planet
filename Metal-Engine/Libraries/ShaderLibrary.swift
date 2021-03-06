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
    case Surface
}

enum FragmentShaderTypes : Int {
    case Basic
    case Surface
}

// Global singleton, manages shader selection
final class ShaderLibrary {
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
        
        vertexShaders.insert(Surface_VertexShader(), at: VertexShaderTypes.Surface.rawValue)
        fragmentShaders.insert(Surface_FragmentShader(), at: FragmentShaderTypes.Surface.rawValue)
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

public class Surface_VertexShader: Shader {
    public var name: String = "Surface Vertex Shader"
    public var functionName: String = "surface_vertex_shader"
    public var function: MTLFunction!
    init() {
        function = ShaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
    }
}

public class Surface_FragmentShader: Shader {
    public var name: String = "Surface Fragment Shader"
    public var functionName: String = "surface_fragment_shader"
    public var function: MTLFunction!
    init() {
        function = ShaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
    }
}

