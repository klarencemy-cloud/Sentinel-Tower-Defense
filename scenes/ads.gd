extends Control

@onready var image: TextureRect = $TextureRect
func _ready() -> void:
	add_to_group("AdPopup")
func setup(texture: Texture2D):
	image.texture = texture
	image.custom_minimum_size = texture.get_size()
	image.size = texture.get_size()
	size = texture.get_size()
	

func _on_button_pressed():
	queue_free()
	var remaining := get_tree().get_nodes_in_group("AdPopup").size() - 1

	Data.ads_visible = remaining > 0

	queue_free()
