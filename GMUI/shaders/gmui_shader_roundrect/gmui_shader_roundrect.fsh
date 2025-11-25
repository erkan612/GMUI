varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_size;              // Width & height (in pixels) of the drawn quad / sprite
uniform float u_radius;           // Corner radius (pixels)
uniform float u_smooth;           // Anti-alias smoothing distance (pixels)
uniform vec4 u_color;             // Fallback/tint color (RGBA). If you sample a texture, it's multiplied.

// Signed-distance function for rounded rectangle
// p = point relative to rectangle center
// b = half extents minus radius
float sdRoundedRect(vec2 p, vec2 b, float r)
{
    vec2 q = abs(p) - b;
    vec2 qmax = max(q, vec2(0.0, 0.0));
    float outside = length(qmax) - r;
    float inside = min(max(q.x, q.y), 0.0);
    return outside + inside;
}

void main()
{
    vec2 pos = v_vTexcoord * u_size;

    vec2 center = u_size * 0.5;
    vec2 p = pos - center;

    vec2 h = u_size * 0.5;
    vec2 b = h - vec2(u_radius, u_radius);

    float dist = sdRoundedRect(p, b, u_radius);

    float mask = 1.0 - smoothstep(0.0, u_smooth, dist);

    vec4 base = texture2D(gm_BaseTexture, v_vTexcoord);

    vec4 col = base * v_vColour * u_color;
    col.a *= mask;

    gl_FragColor = col;
}
