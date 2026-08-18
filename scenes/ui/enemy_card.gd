extends Button

var id: Data.Enemy = Data.Enemy.DEFAULT
signal press(enemy_enum: Data.Enemy)

func setup(new_id: Data.Enemy) -> void:
	id = new_id
	
	var enemy_name = Data.Enemy.keys()[id].capitalize()
	
	$TextureRect/Label.text = enemy_name
	$TextureRect/TextureRect.texture = load(Data.ENEMY_DATA[id]['texture'])


func _on_pressed() -> void:
	UISound.play_click()
	press.emit(id)
