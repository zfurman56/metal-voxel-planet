//
//  SandboxScene.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

//import MetalKit
//
//class SandboxScene: Scene {
//    
//    let debugCamera = DebugCamera()
//    let cube = Cube()
//    let grid = VoxelGrid()
//    
//    override func buildScene() {
//        light = Light(color: float3(1.0,1.0,1.0), direction: float3(0.0, 0.9, 0.435889894354), ambientIntensity: 0.05, diffuseIntensity: 0.9)
//        addCamera(debugCamera)
//        debugCamera.position.z = 5
//        grid.chunks[0].blocks[0][0][0].type = VoxelType.Dirt
//        
//        addCubes()
//    }
//
//    func addCubes(){
//        for chunk in grid.chunks {
//            for y in 0..<16 {
//                for z in 0..<16 {
//                    for x in 0..<16 {
//                        if (chunk.blocks[y][z][x].type == VoxelType.Dirt) {
//                            let cube = Cube()
//                            cube.position.x = Float(x + chunk.position.x)
//                            cube.position.z = Float(z + chunk.position.y)
//                            cube.position.y = Float(y)
//                            cube.scale = float3(0.5)
//                            addChild(cube)
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    override func update(deltaTime: Float) {
//        super.update(deltaTime: deltaTime)
//    }
//}
