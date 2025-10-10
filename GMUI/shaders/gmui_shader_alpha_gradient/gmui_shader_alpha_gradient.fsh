//
// Alpha gradient shader
// u_color: RGB base color
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec3 u_color;

void main() {
    float alpha = v_vTexcoord.x;
    gl_FragColor = vec4(u_color, alpha);
}