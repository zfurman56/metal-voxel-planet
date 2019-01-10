//
//  TextureLibrary.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/25/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

enum TextureTypes : Int {
    case Dirt
    case World
}

// Global singleton, manages texture selection
final class TextureLibrary {
    private static var textures: [Texture] = []
    
    public static func Initialize() {
        createDefaultTextures()
    }
    
    private static func createDefaultTextures(){
        textures.insert(DirtTexture(), at: TextureTypes.Dirt.rawValue)
        textures.insert(WorldTexture(), at: TextureTypes.World.rawValue)
    }
    
    public static func getTexture(_ textureType: TextureTypes)->Texture{
        return textures[textureType.rawValue]
    }
}

protocol Texture: AnyObject {
    var texture: MTLTexture! {get set}
    var fileName: String {get}
    var fileExtension: String {get}
}

final class DirtTexture: Texture {
    var texture: MTLTexture!
    let fileName = "grass"
    let fileExtension = "jpg"
    
    init() {
        let path = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        
        let textureLoader = MTKTextureLoader(device: Engine.Device)
        do {
            try texture = textureLoader.newTexture(URL: path!, options: [.generateMipmaps: true, .allocateMipmaps: true])
        } catch let error as NSError {
            print("Error loading texture!::\(error)")
            return
        }
    }
}

final class WorldTexture: Texture {
    var texture: MTLTexture!
    let fileName = "world_cube_net"
    let fileExtension = "png"
    
    init() {
        let path = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        
        let textureLoader = MTKTextureLoader(device: Engine.Device)
        do {
            try texture = textureLoader.newTexture(URL: path!, options: [.generateMipmaps: true, .allocateMipmaps: true])
        } catch let error as NSError {
            print("Error loading texture!::\(error)")
            return
        }
    }
}
