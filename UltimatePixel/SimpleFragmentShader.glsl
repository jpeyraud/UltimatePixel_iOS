#version 100

precision mediump float;

varying lowp vec4 frag_Color;

void main(void) {
    gl_FragColor = frag_Color;
}
