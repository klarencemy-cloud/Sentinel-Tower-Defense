shader_type canvas_item;

uniform sampler2D noise_texture : repeat_enable, filter_linear;
uniform vec2 speed = vec2(0.02, 0.01);

void fragment() {
    vec2 uv = UV + speed * TIME;

    float noise = texture(noise_texture, uv).r;
    float fog = smoothstep(0.3, 0.8, noise);

    float edge_x = smoothstep(0.0, 0.1, UV.x) *
                   (1.0 - smoothstep(0.9, 1.0, UV.x));
    float edge_y = smoothstep(0.0, 0.1, UV.y) *
                   (1.0 - smoothstep(0.9, 1.0, UV.y));
    float edge = edge_x * edge_y;

    //COLOR = texture(TEXTURE, UV); // or COLOR = COLOR;
    COLOR.a *= fog * edge;
}