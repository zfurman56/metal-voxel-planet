//
//  Renderable.swift
//  Metal-Engine
//
//  Created by Zach Furman on 12/24/18.
//  Copyright © 2018 Zach Furman. All rights reserved.
//

import MetalKit

protocol Renderable: AnyObject {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder)
}


