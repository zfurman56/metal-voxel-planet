# metal-voxel-planet
A proof-of-concept for a spherical voxel planet written in Swift using Metal.

## Overview

This is a demo of a 3D, voxel planet. In other words, think of a spherical planet made of "Minecraft"-like blocks.

![Screenshot](https://i.imgur.com/VnNVmb5.jpg)

## Why this matters

Mapping a cubic grid to a sphere sounds impossible. And that's because, well, it is. It's mathematically impossible
to map any sort of plane (like a cube) to a sphere without distortion. This distortion causes a lot of problems
near the surface of the sphere, and creates especially troublesome edge cases near edges and corners of the cube.

So how do we solve this? Instead, what we can do is lie a little bit. We have two possible planet representations that
we transition between. Farther away from the surface ("in space"), the planet actually is a sphere, and the camera's far
enough away from the surface that it doesn't matter that we don't render voxels. Closer to the surface, the planet is just
represented as a plane, and the voxels lie on a typical planar grid. We warp the terrain in the vertex shader to appear
spherical, but internally, it's still flat. At some distance from the surface, we transition between the space
representation and the surface representation. In the worst case, there will some minor discontinuities in the transition
due to distortion, but these are temporary and easily disguised.
