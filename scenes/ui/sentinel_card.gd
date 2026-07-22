extends Button

var id: Data.Sentinel = Data.Sentinel.SYSAD
signal press(sentinel_enum: Data.Sentinel)

func setup(new_id: Data.Sentinel) -> void:
	id = new_id

	var sentinel_name = Data.Sentinel.keys()[id].capitalize()
	$TextureRect/Label.text = sentinel_name
	$TextureRect/TextureRect.texture = load(Data.SENTINEL_DATA[id]['thumbnail'])


func _ready() -> void:
	if not is_in_group("SentinelCard"):
		add_to_group("SentinelCard	")
func _on_pressed() -> void:
	press.emit(id)
