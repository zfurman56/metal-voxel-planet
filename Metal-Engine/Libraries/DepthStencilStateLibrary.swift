//
//  DepthStencilStateLibrary.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

enum DepthStencilStateTypes : Int {
    case Less
}

// Global singleton, contains rendering options for depth buffer
final class DepthStencilStateLibrary {
    
    private static var _depthStencilStates: [DepthStencilState] = []
    
    public static func Intitialize(){
        createDefaultDepthStencilStates()
    }
    
    private static func createDefaultDepthStencilStates(){
        _depthStencilStates.insert(Less_DepthStencilState(), at: DepthStencilStateTypes.Less.rawValue)
    }
    
    public static func DepthStencilState(_ depthStencilStateType: DepthStencilStateTypes)->MTLDepthStencilState{
        return _depthStencilStates[depthStencilStateType.rawValue].depthStencilState
    }
    
}

protocol DepthStencilState: AnyObject {
    var depthStencilState: MTLDepthStencilState! { get }
}

class Less_DepthStencilState: DepthStencilState {
    
    var depthStencilState: MTLDepthStencilState!
    
    init() {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilState = Engine.Device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
    
}

