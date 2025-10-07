//
// Saturation/Brightness area shader
// u_hue: current hue value (0-1)
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float u_hue;

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    float saturation = v_vTexcoord.x;
    float brightness = 1.0 - v_vTexcoord.y; // Invert Y so bright is at top
    vec3 hsv = vec3(u_hue, saturation, brightness);
    vec3 rgb = hsv2rgb(hsv);
    gl_FragColor = vec4(rgb, 1.0);
}