//
//  SurfaceShaders.metal
//  Metal-Engine
//
//  Created by Zach Furman on 1/9/19.
//  Copyright © 2019 Zach Furman. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position [[ attribute(0) ]];
    float2 texel [[ attribute(1) ]];
    float3 normals [[ attribute(2) ]];
};

struct RasterizerData {
    float4 position [[position]];
    float2 texel;
    float3 normals;
};

struct Light{
    float3 color;
    float3 direction;
    float ambientIntensity;
    float diffuseIntensity;
};

struct Uniforms {
    float4x4 modelViewMatrix;
    float4x4 projectionMatrix;
    float3x3 normalMatrix;
};

vertex RasterizerData surface_vertex_shader(const VertexIn vIn [[ stage_in ]],
                                          constant Uniforms &uniforms [[ buffer(1) ]]) {
    
    RasterizerData rd;
    rd.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * float4(vIn.position, 1);
    rd.texel = vIn.texel;
    rd.normals = uniforms.normalMatrix*vIn.normals;
    
    return rd;
}

fragment half4 surface_fragment_shader(RasterizerData rd [[ stage_in ]],
                                     constant Light &light [[ buffer(3) ]],
                                     texture2d<float> texture [[ texture(0) ]]) {
    
    constexpr sampler textureSampler (mag_filter::nearest,
                                      min_filter::nearest,
                                      mip_filter::nearest,
                                      address::clamp_to_edge);
    
    float4 textureColor = texture.sample(textureSampler, rd.texel);
    
    float4 ambientColor = float4(light.color * light.ambientIntensity, 1);
    
    float diffuseFactor = max(0.0, dot(rd.normals, light.direction)); // 1
    float4 diffuseColor = float4(light.color * light.diffuseIntensity * diffuseFactor, 1.0);
    
    float4 color = textureColor * (ambientColor + diffuseColor);
    return half4(color.r, color.g, color.b, 1);
}
