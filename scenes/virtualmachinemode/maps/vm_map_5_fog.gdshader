shader_type canvas_item;

uniform sampler2D noise_texture : repeat_enable, filter_linear;
uniform vec2 speed = vec2(0.02, 0.01);
uniform float density_low : hint_range(0.0, 1.0) = 0.22;
uniform float density_high : hint_range(0.0, 1.0) = 0.68;
uniform float edge_softness : hint_range(0.05, 0.9) = 0.62;
uniform float edge_warp : hint_range(0.0, 0.6) = 0.35;

void fragment() {
    vec2 uv = UV + speed * TIME;

    float n1 = texture(noise_texture, uv).r;
    float n2 = texture(noise_texture, uv * 2.3 + vec2(3.7, 1.3) - speed * TIME * 0.6).r;
    float n3 = texture(noise_texture, uv * 4.1 + vec2(9.1, 4.4) + speed * TIME * 0.9).r;
    float density = n1 * 0.5 + n2 * 0.32 + n3 * 0.18;
    float fog = smoothstep(density_low, density_high, density);

    vec2 centered = UV - vec2(0.5);
    float warp = texture(noise_texture, uv * 0.8 + vec2(9.0, 4.0)).r;
    float dist = length(centered) * 2.0 + (warp - 0.5) * edge_warp;
    float edge = 1.0 - smoothstep(1.0 - edge_softness, 1.0, dist);

    COLOR.a *= fog * edge;
}
