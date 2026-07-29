shader_type canvas_item;
render_mode blend_add; // This makes it ‘glow’ against the world

uniform vec4 glow_color : source_color = vec4(1.0, 0.9, 0.5, 1.0);
uniform float intensity : hint_range(0.0, 5.0) = 1.5;
uniform float spread : hint_range(0.1, 2.0) = 1.0;
uniform float pulse_speed : hint_range(0.0, 10.0) = 1.0;

void fragment() {
  // 1. Get the shape of your sprite
  float sprite_shape = texture(TEXTURE, UV).a;
   
  // 2. Your original circle logic
  vec2 centered_uv = UV - vec2(0.5);
  float dist = length(centered_uv) * spread;
  float alpha = max(0.0, 1.0 - dist);
   
  // 3. Your original pulse logic
  alpha *= (1.0 + 0.2 * sin(TIME * pulse_speed));
  alpha = clamp(alpha * intensity, 0.0, 1.0);
   
  // 4. THE FIX: Multiply by sprite_shape so the glow stays 
  // within the bounds of the sprite (prevents a giant square box)
  COLOR = glow_color * alpha * sprite_shape;
}