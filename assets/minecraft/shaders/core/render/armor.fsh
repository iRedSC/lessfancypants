#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;
in vec4 tintColor;
in vec4 lightColor;
in vec4 overlayColor;
in vec2 uv;
in vec4 normal;
flat in vec2 size;
flat in int n;
flat in int i;

out vec4 fragColor;

void main() {
    float time = GameTime*1200;
    vec2 anim = vec2(0);
    switch (i) {
        case 0: anim += time;
    }
    vec2 uv2 = mod(uv + anim / size, vec2(0.125, 0.25/n + i*size.x/size.y/2.));
    vec4 color = texture(Sampler0, uv);
    vec4 effect = texture(Sampler0, uv2);
    color = vec4(mix(color.rgb, effect.rgb, effect.a*color.a), color.a);
    if (color.a < 0.1) discard;
    color *= tintColor * ColorModulator;
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
    color *= vertexColor * lightColor; //shading
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}