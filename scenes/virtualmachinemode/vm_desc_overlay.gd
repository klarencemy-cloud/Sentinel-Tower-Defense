extends CanvasLayer

signal dismissed()

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
	"The S.E.R.V.E.R. is malfunctioning and is losing health every 5 seconds! Defeat 200 Virus enemies before its health reaches zero. Gear up and keep the system alive!",
	"A massive swarm of Worms and Spams is flooding every path from every direction! Defeat 1,000 enemies without taking any damage. Hold your ground and survive the overwhelming swarm!",
	"The S.E.R.V.E.R. has only 1 HP remaining! Survive 7 waves without taking a single hit from malware enemies. One mistake could cost you everything. Defend the S.E.R.V.E.R. at any cost!",
	"A Botnet swarm is on the attack! Inspired by a real-world cyber attack, countless low-power Botnet nodes are rushing to take over the S.E.R.V.E.R. Defeat them and survive seven waves. Break them before they overtake and defeat you!",
	"Fog has covered parts of the map, creating blind spots where enemies cannot be targeted. Survive 7 waves to keep the S.E.R.V.E.R. running. Trust your defenses and watch every path!",
	"The S.E.R.V.E.R. is flooded by massive internet traffic! DDoS attacks are overwhelming the system. Defeat 300 enemies before the timer runs out. Keep the defenses alive and prove that the S.E.R.V.E.R. can survive the flood!",
	"Your defenses are out of your control! Towers randomly appear, and you must place them wisely to reach victory. Survive 7 waves to win. Prove your worth and outsmart this unpredictable challenge!",
	"The Sentinels have been disabled! The S.E.R.V.E.R. is counting on you and your towers.  Survive 7 waves without Sentinel supporting you!",
	"The attack never ends! The enemies are evolving and ever-changing. Waves of enemies will continue attacking the S.E.R.V.E.R. for as long as you can survive. Keep your defenses alive until the very end!"

]

func _ready() -> void:
	$Control/Overlay2/Map1.texture = load(map_texture[Data.vmmode_map_number - 1]);
	$Control/Overlay2/Map1/vmName.text = vm_title_array[Data.vmmode_map_number - 1]
	$Control/Overlay2/Map1/vmName/Description.text = vm_map_desc_paragraph[Data.vmmode_map_number - 1]
	
	if Data.is_vmmode:
		$'.'.show()
		$Control/AnimationPlayer.play("vm_pop")
		UISound.play_click()
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
			dismissed.emit()
