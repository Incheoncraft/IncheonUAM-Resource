#version 150

in vec4 vertexColor;

uniform vec4 ColorModulator;

out vec4 fragColor;

void main() {
    vec4 color = vertexColor;
    if (color.a == 0.0) {
        discard;
    }
    fragColor = color * ColorModulator;
    if (color.r == 1.0 && color.g == 1.0 && color.b == 1.0 && color.a == 127.0/255.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
}
