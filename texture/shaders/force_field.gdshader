shader_type canvas_item;

uniform vec4 Color_Shield : source_color = vec4(1.0);
uniform float Step = 0.5;
uniform vec2 Speed = vec2(0.1, 0.1);
uniform float Size_Inner = 0.0;
uniform float Opaticy = 1.0;
uniform float Size_Outer = 0.0;

vec2 sphericalFunc(
	vec2 uv,
	vec2 pos,
	vec2 radius,
	vec2 spin,
	vec2 location
) {
	vec2 temp_p = (uv - pos) * 2.0;

	float temp_rad = length(
		(temp_p - location) * radius
	) + 0.0001;

	float temp_f = (
		1.0 - sqrt(
			max(0.0, 1.0 - temp_rad)
		)
	) / temp_rad;

	return mod(
		vec2(
			(temp_p.x * 0.5 * temp_f + spin.x) + 0.5,
			(temp_p.y * 0.5 * temp_f + spin.y) + 0.5
		),
		vec2(1.0)
	);
}

vec2 tilingNoffsetAnimatedFunc(
	vec2 uv,
	float time,
	vec2 offset
) {
	return vec2(
		mod(uv.x + offset.x * time, 1.0),
		mod(uv.y + offset.y * time, 1.0)
	);
}
void fragment() {
	vec2 spherical_uv = sphericalFunc(
		UV,
		vec2(0.5),
		vec2(1.0),
		vec2(0.0),
		vec2(0.0)
	);

	vec2 animated_uv = tilingNoffsetAnimatedFunc(
		spherical_uv,
		TIME,
		Speed
	);

	vec4 tex = texture(TEXTURE, animated_uv);

	float distance_from_center = distance(
		UV,
		vec2(0.5)
	);

	float circle_mask = 1.0 - step(
		0.5,
		distance_from_center
	);

	float inner_mask = step(
		Size_Inner,
		distance_from_center
	);

	float outer_mask = 1.0 - step(
		Size_Outer,
		distance_from_center
	);

	float final_mask = circle_mask;
	final_mask *= inner_mask;
	final_mask *= outer_mask;

	COLOR.rgb = tex.rgb * Color_Shield.rgb;
	COLOR.a = tex.a * Color_Shield.a * final_mask * Opaticy;
}
