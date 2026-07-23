extends Button

var id: Data.Sentinel
signal press(sentinel_enum: Data.Sentinel)

func setup(new_id: Data.Sentinel) -> void:
	id = new_id

	var sentinel_name = Data.SENTINEL_DATA[id]["name"].capitalize()
	$TextureRect/Label.text = sentinel_name
	$TextureRect/TextureRect.texture = load(Data.SENTINEL_DATA[id]['thumbnail'])


func _ready() -> void:
	if not is_in_group("SentinelCard"):
		add_to_group("SentinelCard")

	Data.deactivate.connect(toggle_active)
	

func _on_pressed() -> void:
	press.emit(id)

func toggle_active():
	match id:
		Data.Sentinel.SYSAD:
			disabled = Data.sentinel_sysad_deployed
		Data.Sentinel.INTRUSION:
			disabled = Data.sentinel_intrusion_deployed
		Data.Sentinel.SECURITY:
			disabled = Data.sentinel_security_deployed
		Data.Sentinel.MALWARE:
			disabled = Data.sentinel_malware_deployed
		Data.Sentinel.DECEPTION:
			disabled = Data.sentinel_deception_deployed
