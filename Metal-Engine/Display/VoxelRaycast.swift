//
//  VoxelRaycast.swift
//  
//
//  Created by Zach Furman on 12/28/18.
//

import simd
import Foundation

func RotationToUnitVector(rotation: float3)->float3 {
    return float3(-cos(rotation.x)*sin(rotation.y), sin(rotation.x), -cos(rotation.x)*cos(rotation.y))
}

// Heavily based on:
// http://gamedev.stackexchange.com/a/49423/8806
// https://gist.github.com/dogfuntom/cc881c8fc86ad43d55d8
class VoxelRaycast
{

    /**
     * Call the callback with (position, face) of all blocks along the line
     * segment from point 'origin' in vector direction 'direction' of length
     * 'radius'. 'radius' may be infinite, but beware infinite loop in this case.
     *
     * 'face' is the normal vector of the face of that block that was entered.
     *
     * If the callback returns a true value, the traversal will be stopped.
     */
    public static func raycast(
        origin: float3,
        direction: float3,
        radius: Float,
        callback: (float3)->Bool) -> float3?
    {
        // From "A Fast Voxel Traversal Algorithm for Ray Tracing"
        // by John Amanatides and Andrew Woo, 1987
        // <http://www.cse.yorku.ca/~amana/research/grid.pdf>
        // <http://citeseer.ist.psu.edu/viewdoc/summary?doi=10.1.1.42.3443>
        // Extensions to the described algorithm:
        //   • Imposed a distance limit.
        //   • The face passed through to reach the current cube is provided to
        //     the callback.

        // The foundation of this algorithm is a parameterized representation of
        // the provided ray,
        //                    origin + t * direction,
        // except that t is not actually stored rather, at any given point in the
        // traversal, we keep track of the *greater* t values which we would have
        // if we took a step sufficient to cross a cube boundary along that axis
        // (i.e. change the integer part of the coordinate) in the variables
        // tMaxX, tMaxY, and tMaxZ.

        // Cube containing origin point.
        var x: Float = floor(origin[0])
        var y: Float = floor(origin[1])
        var z: Float = floor(origin[2])

        // Break out direction vector.
        let dx: Float = direction[0]
        let dy: Float = direction[1]
        let dz: Float = direction[2]

        // Direction to increment x,y,z when stepping.
        let stepX: Int = signum(dx)
        let stepY: Int = signum(dy)
        let stepZ: Int = signum(dz)

        // See description above. The initial values depend on the fractional
        // part of the origin.
        var tMaxX: Float = intbound(origin[0], dx)
        var tMaxY: Float = intbound(origin[1], dy)
        var tMaxZ: Float = intbound(origin[2], dz)

        // The change in t when taking a step (always positive).
        let tDeltaX = Float(stepX) / dx
        let tDeltaY = Float(stepY) / dy
        let tDeltaZ = Float(stepZ) / dz

        // Buffer for reporting faces to the callback.
//        var face: int3 = int3(0)

        // Avoids an infinite loop.
        if (dx == 0 && dy == 0 && dz == 0) {
            print("Ray-cast in zero direction!")
        }

        // Rescale from units of 1 cube-edge to units of 'direction' so we can
        // compare with 't'.
        let maxRadius = radius / sqrt(dx * dx + dy * dy + dz * dz)

        while (true) {
            // Invoke the callback
            if (callback(float3(x, y, z))) {
                return float3(x, y, z)
            }

            // tMaxX stores the t-value at which we cross a cube boundary along the
            // X axis, and similarly for Y and Z. Therefore, choosing the least tMax
            // chooses the closest cube boundary. Only the first case of the four
            // has been commented in detail.
            if (tMaxX < tMaxY)
            {
                if (tMaxX < tMaxZ)
                {
                    if (tMaxX > maxRadius) {
                        return nil
                    }
                    // Update which cube we are now in.
                    x += Float(stepX)
                    // Adjust tMaxX to the next X-oriented boundary crossing.
                    tMaxX += tDeltaX
                    // Record the normal vector of the cube face we entered.
//                    face[0] = -stepX
//                    face[1] = 0
//                    face[2] = 0
                }
                else
                {
                    if (tMaxZ > maxRadius) {
                        return nil
                    }
                    z += Float(stepZ)
                    tMaxZ += tDeltaZ
//                    face[0] = 0
//                    face[1] = 0
//                    face[2] = -stepZ
                }
            }
            else
            {
                if (tMaxY < tMaxZ)
                {
                    if (tMaxY > maxRadius) {
                        return nil
                    }
                    y += Float(stepY)
                    tMaxY += tDeltaY
//                    face[0] = 0
//                    face[1] = -stepY
//                    face[2] = 0
                }
                else
                {
                    // Identical to the second case, repeated for simplicity in
                    // the conditionals.
                    if (tMaxZ > maxRadius) {
                        return nil
                    }
                    z += Float(stepZ)
                    tMaxZ += tDeltaZ
//                    face[0] = 0
//                    face[1] = 0
//                    face[2] = -stepZ
                }
            }
        }
    }

    private static func intbound(_ s: Float, _ ds: Float)->Float {
        // Some kind of edge case, see:
        // http://gamedev.stackexchange.com/questions/47362/cast-ray-to-select-block-in-voxel-game#comment160436_49423
        let sIsInteger: Bool = (round(s) == s)

        if (ds < 0 && sIsInteger) {
            return 0
        }

        return (ds > 0 ? ceil(s) - s : s - floor(s)) / abs(ds)
    }

    private static func signum(_ x: Float)->Int {
        return x > 0 ? 1 : x < 0 ? -1 : 0
    }
}
