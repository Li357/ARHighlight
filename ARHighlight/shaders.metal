//
//  HighlightRender.metal
//  ARHighlight
//
//  Created by Andrew Li on 12/2/18.
//  Copyright © 2018 Andrew Li. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>

typedef struct {
    float4 position [[attribute(SCNVertexSemanticPosition)]];
} custom_vertex_t;

typedef struct {
    float4 position [[position]];
    float2 uv;
} out_vertex_t;

constexpr sampler s = sampler(coord::normalized,
                              address::repeat,
                              filter::linear);

vertex out_vertex_t passthrough_vertex(custom_vertex_t in [[stage_in]]) {
    out_vertex_t out;
    out.position = in.position;
    out.uv = float2((in.position.x + 1.0) * 0.5 , (in.position.y + 1.0) * -0.5);
    return out;
};

fragment half4 combine_fragment(out_vertex_t vert [[stage_in]],
                                texture2d<float, access::sample> background [[texture(0)]],
                                texture2d<float, access::sample> highlights [[texture(1)]]) {
    float4 bgColor = background.sample(s, vert.uv);
    float4 hlColor = highlights.sample(s, vert.uv);
    return half4(bgColor * 0.1 + hlColor); // Dims background by 90%
}
