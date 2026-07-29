@tool
extends RichTextEffect
class_name RichTextBinary

# Syntax: [matrix clean=2.0 dirty=1.0 span=50][/matrix]

# Define the tag name.
var bbcode = "binary"

# Gets TextServer for retrieving font information.
func get_text_server():
	return TextServerManager.get_primary_interface()

func _process_custom_fx(char_fx):
	# Get parameters, or use the provided default value if missing.
	var clear_time = char_fx.env.get("clean", 2.0)
	var dirty_time = char_fx.env.get("dirty", 1.0)
	var text_span = char_fx.env.get("span", 50)

	var value = get_text_server().font_get_char_from_glyph_index(char_fx.font, 1, char_fx.glyph_index)

	var matrix_time = fmod(char_fx.elapsed_time + (char_fx.range.x / float(text_span)), \
						   clear_time + dirty_time)

	if matrix_time > 0.0:
		var tick = int(char_fx.elapsed_time * 20.0)
		var hash = tick * 1103515245 + int(char_fx.range.x) * 12345
		value = 65 + (abs(hash) % 26)

	char_fx.glyph_index = get_text_server().font_get_glyph_index(char_fx.font, 1, value, 0)
	return true