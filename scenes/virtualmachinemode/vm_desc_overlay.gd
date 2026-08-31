extends CanvasLayer

var skippable: bool = false


var map_texture: Array = [
	"res://graphics/map/challenge1.png",
	"res://graphics/map/challenge2.png",
	"res://graphics/map/challenge3.png",
	"res://graphics/map/challenge4.png",
	"res://graphics/map/challenge5.png",
	"res://graphics/map/challenge6.png",
	"res://graphics/map/challenge7.png",
	"res://graphics/map/challenge8.png",
	"res://graphics/map/challenge9.png"
]

var vm_title_array: Array = ["Ticking Bomb", "Swarm Overload", "Malware Interruption", "Mirai Botnet", "Packet Loss", "DDoS Stress Test", "Random Defense", "Automatic Defense", "Endless Onslaught"]
var vm_map_desc_paragraph: Array = [
	"The S.E.R.V.E.R. malfunctions; it loses health every 5 seconds. Defeat 200 virus enemies before the S.E.R.V.E.R. health reaches 0.",
	"A massive outbreak of Worms and Spam floods the paths. Defeat 1,000 enemies without taking any damage.",
	"The S.E.R.V.E.R. has only 1 HP left. Win the game without taking any damage from malware enemies for 7 waves. A single damage will cost the player everything. The player must defend the S.E.R.V.E.R. at any cost.",
	"Inspired by a real-world exploit, a large number of Botnet drone that mainly compromise low-power devices swarms fast to attack the S.E.R.V.E.R., but are fragile as individuals. Win 7 waves to win the challenge.",
	"The map has blind spots (fog), whenever enemies are in that location, they cannot be targeted. Win 7 waves to win the challenge.",
	"Only Distributed Denial-of-Service (DDoS) attacks the S.E.R.V.E.R. to test how it handles floods of internet traffic. The player must defeat 300 enemies before the timer runs out.",
	"Random towers randomly appear. The player must place them correctly and strategically. Win 7 waves to win the challenge.",
	"All sentinels are disabled during the challenge. Win 7 waves to win the challenge.",
	"This challenge is endless. A survival game where the player must defend the S.E.R.V.E.R. with an endless number of waves."

]

func _ready() -> void:
	$Control/Overlay2/Map1.texture = load(map_texture[Data.vmmode_map_number - 1]);
	$Control/Overlay2/Map1/vmName.text = vm_title_array[Data.vmmode_map_number - 1]
	$Control/Overlay2/Map1/vmName/Description.text = vm_map_desc_paragraph[Data.vmmode_map_number - 1]
	
	if Data.is_vmmode:
		$'.'.show()
		$Control/AnimationPlayer.play("vm_pop")
	skippable = false

func _process(delta: float) -> void:
	if skippable:
		$Control.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		$Control.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	skippable = true


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and skippable:
			UISound.play_close()
			$Control/AnimationPlayer.play_backwards("vm_pop")
			skippable = false
			await get_tree().create_timer(0.5).timeout
			$'.'.hide()
