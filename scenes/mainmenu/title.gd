@tool
extends RichTextEffect
class_name RichTextDecrypt

# Usage:
# [decrypt speed=0.08 freq=20]SERVER ONLINE[/decrypt]

var bbcode = "matrix"

func get_text_server() -> TextServer:
	return TextServerManager.get_primary_interface()

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var speed: float = char_fx.env.get("speed", 0.1) # delay between letters
	var frequency: float = char_fx.env.get("freq", 20.0) # tick per second

	# character reveal
	var reveal_time = char_fx.range.x * speed

	# keep the original character
	if char_fx.elapsed_time >= reveal_time:
		return true

	# random uppercase letter
	var tick = int(char_fx.elapsed_time * frequency)
	var hash = tick * 1103515245 + int(char_fx.range.x) * 12345
	var unicode = "A".unicode_at(0) + (abs(hash) % 26)

	char_fx.glyph_index = get_text_server().font_get_glyph_index(
		char_fx.font,
		1,
		unicode,
		0
	)

	return true
