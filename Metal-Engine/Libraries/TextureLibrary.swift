//
//  TextureLibrary.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/25/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

enum TextureTypes {
    case Dirt
}

class Texture {
    var texture: MTLTexture!
    
    init(device: MTLDevice, filename: URL) {
        let textureLoader = MTKTextureLoader(device: device)
        do {
            try texture = textureLoader.newTexture(URL: filename, options: [.generateMipmaps: true, .allocateMipmaps: true])
        } catch {
            print("Error loading texture!")
            return
        }
    }
}

class TextureLibrary {
    private static var textures: [TextureTypes: Texture] = [:]
    
    public static func Initialize(device: MTLDevice) {
        createDefaultTextures(device: device)
    }
    
    private static func createDefaultTextures(device: MTLDevice){
        var path: URL!
            
        path = Bundle.main.url(forResource: "grass", withExtension: "jpg")
        textures.updateValue(Texture(device: device, filename: path), forKey: .Dirt)
    }
    
    public static func getTexture(_ textureType: TextureTypes)->Texture{
        return textures[textureType]!
    }
}
