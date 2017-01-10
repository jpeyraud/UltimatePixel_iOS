#version 100

precision highp float;

varying lowp vec4 frag_Color;

uniform float globalTime;
uniform float resX;
uniform float resY;


vec3 hsv2rgb (in vec3 hsv) {
    hsv.yz = clamp (hsv.yz, 0.0, 1.0);
    return hsv.z * (1.0 + 0.5 * hsv.y * (cos (2.0 * 3.14159 * (hsv.x + vec3 (0.0 / 3.0, 1.0 / 3.0, 2.0 / 3.0))) - 1.0));
}

float rand (in vec2 seed) {
    return fract (sin (dot (seed, vec2 (12.9898, 78.233))) * 137.5453);
}

vec4 mainImage (in vec2 fragCoord) {
    vec2 frag = (2.0 * fragCoord.xy - vec2(resX,resY)) / resY;
    
    //crazy effect
    //frag *= 2.0 - 0.2 * sin (frag.yx* globalTime/2.0) * cos (3.14159 * 0.5 * globalTime);
    //first effect
    //frag *= 2.0 - 0.4 * cos (frag.yx) * sin (3.14159 * 0.5 * globalTime);
    //current
    //frag *= 2.0 - 0.4 * cos (frag.yx) * sin (3.14159 * 0.5 * globalTime);
    
    // Other
    frag *= 9.8;
    float random = rand (floor (frag));
    
    // square
    vec2 black = smoothstep (1.0, 0.8, cos (frag * 3.14159 * 2.0));
    
    // color
    vec3 color = hsv2rgb (vec3 (random, 1.0, 1.0));
    color *= black.x * black.y * smoothstep (1.0, 0.0, length (fract (frag) - 0.5));
    color *= 0.5 + 0.5 * cos (random + random * globalTime + globalTime/3.0 + 3.14159 * 0.5);
    return vec4 (color, 1.0);
}

void main() {
    gl_FragColor = mainImage(gl_FragCoord.xy);
}
