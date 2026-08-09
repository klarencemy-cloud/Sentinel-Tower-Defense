shader_type canvas_item;

uniform int  spiral_type : hint_range(1,5) = 1;
uniform vec3 color : source_color;
uniform float rays : hint_range(0.,20., 1) = 6;
uniform float speed : hint_range(0., 20., .01) = .5;
uniform float fade : hint_range(0., 3., .01) = .1;
uniform float thickness : hint_range(0., 1., .01) = .3;
uniform bool clockwise = true;

// not used by all sprials
uniform float tiers: hint_range(0., 20., 1) = 4;
uniform float stretch : hint_range(0., 10., .1) = 6.28;
uniform vec3 s5color2 : source_color;

void fragment() {
	float r = length(.5 - UV);
	float angle = atan(UV.y-.5, UV.x-.5);
	COLOR.rgb = color;
	
	if (spiral_type == 1)
		COLOR.a = 1. - smoothstep(-.1, .1, fract((2.*r-(angle+PI)/TAU)*rays + 
										(clockwise?1.:-1.)* TIME*speed)-thickness);
	if (spiral_type == 2)
		COLOR.a = 1. - smoothstep(0., thickness, abs(.5 - fract((2.*r-(angle+PI)/TAU)*rays + (clockwise?1.:-1.)* TIME*speed) ) );
	if (spiral_type == 3)
		COLOR.a *= 1. - smoothstep(0.0, thickness, fract(tiers*(2.*r))/tiers - mod(tiers*(angle+PI)- (clockwise?1.:-1.)*TIME,TAU)/(stretch*tiers) );
	if (spiral_type == 4)
		COLOR.a *= 1. - smoothstep(0.0, thickness, abs(fract(tiers*(2.*r))/tiers - mod(tiers*(angle+PI)- (clockwise?1.:-1.)*TIME,TAU)/(stretch*tiers)) );
	if (spiral_type == 5)
		COLOR.rgb = mix(color, s5color2, thickness*fract((2.*r-(angle+PI)/TAU)*rays + 
										(clockwise?1.:-1.)* TIME*speed) );
	
	COLOR.a *= pow(2.*(.5 - r), fade*4.);
}