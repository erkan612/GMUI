//
// Checkerboard pattern shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 u_size;

void main() {
    vec2 uv = v_vTexcoord * u_size / 8.0; // 8x8 pixel checker pattern
    bool x = mod(uv.x, 2.0) > 1.0;
    bool y = mod(uv.y, 2.0) > 1.0;
    bool check = (x && !y) || (!x && y);
    float color = check ? 0.7 : 0.5; // Light and dark gray
    gl_FragColor = vec4(color, color, color, 1.0);
}