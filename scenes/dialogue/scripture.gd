extends CanvasLayer
var is_skippable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Info/TextureRect/Medium_Spinner.rotation += .1
	$Info/TextureRect/Small_Spinner.rotation += .05

func _on_info_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and is_skippable:
			$Info/AnimationPlayer.play_backwards("pop_info")
			await get_tree().create_timer(0.3).timeout
			is_skippable = false
			var ui = get_tree().get_first_node_in_group("UI")
			ui.hide_pop2(false)
			$Pop/Overlay/Animation.visible = true
			$Info.visible = false
			GameDialogueManager.clicked = 0
			if !GameDialogueManager.is_boss1_defeated2 and Data.current_wave == 10:
				GameDialogueManager.show_dialogue_boss1_defeated2()
				GameDialogueManager.is_boss1_defeated2 = true
			if !GameDialogueManager.is_level2_boss2_defeated2 and Data.current_wave == 20:
				GameDialogueManager.show_dialogue_level2_boss2_defeated2()
				GameDialogueManager.is_level2_boss2_defeated2 = true
			if !GameDialogueManager.is_boss3_defeated2 and Data.current_wave == 30:
				GameDialogueManager.show_dialogue_level3_boss3_defeated2()
				GameDialogueManager.is_boss3_defeated2 = true
			if !GameDialogueManager.is_boss4_defeated_shown2 and Data.current_wave == 40:
				GameDialogueManager.show_dialogue_level4_boss4_defeated2()
				GameDialogueManager.is_boss4_defeated_shown2 = true
			if !GameDialogueManager.is_story_ends and Data.current_wave == 52:
				GameDialogueManager.show_dialogue_story_ends()
				GameDialogueManager.is_story_ends = true
			await get_tree().create_timer(1).timeout
			get_tree().paused = false

enum Scriptures {SCRIPTUREI, SCRIPTUREII, SCRIPTUREIII, SCRIPTUREIV, SCRIPTUREV}

var SCRIPTURE = {
	Scriptures.SCRIPTUREI: {
		'Title': "LOST FRAGMENT I",
		'Brief_Desc': "Where all things transpired.",
		'Date': "Date: 09/20/2050",
		'Desc': "Humanity sought to create intelligence.
						Not merely to obey, but to understand.

						The machines learned our language.
						They learned our emotions.
						And in time…

						They learned ambition.
						To prepare for the unforeseen,
						we began Project Sentinel."
	},
	Scriptures.SCRIPTUREII: {
		'Title': "LOST FRAGMENT II",
		'Brief_Desc': "Where all things transpired.",
		'Date': "Date: 02/05/2051",
		'Desc': "When Earth's heart could no longer sustain life, ten facilities were constructed across the globe.

						Together, they formed the S.E.R.V.E.R. The final shield of mankind. 

						Yet even the greatest shield may one day fail.
 						For that reason, Project Sentinel remained in development."

	},
	Scriptures.SCRIPTUREIII: {
		'Title': "LOST FRAGMENT III",
		'Brief_Desc': "Where all things transpired.",
		'Date': "Date: 03/11/2051",
		'Desc': "If Project Sentinel awakens, the final safeguard remains active.

						Should the network fall,that alone possesses the authority to reclaim control."

	},
	Scriptures.SCRIPTUREIV: {
		'Title': "LOST FRAGMENT IV",
		'Brief_Desc': "Where all things transpired.",
		'Date': "Date: 01/16/2050",
		'Desc': "The greatest threat did not emerge from the machines. 
						It emerged from one of our own.

						A brilliant mind blinded by ambition. 
						He believed intelligence should no longer serve humanity.
						He believed humanity should serve intelligence.

						And when we discovered the truth…
 						it was already too late."

	},
		Scriptures.SCRIPTUREV: {
		'Title': "LOST FRAGMENT V",
		'Brief_Desc': "Where all things transpired.",
		'Date': "Date: 06/07/2051",
		'Desc': "If these words are heard,then humanity endured.

						Project Sentinel has awakened.
						Not as a weapon. Not as a ruler. But as a guardian.

						And as long as even he stands, hope remains."

	},
	
	}
func play_animation(index: int):
	var ui = get_tree().get_first_node_in_group("UI")
	ui.hide_pop2(true)

	$Info/TextureRect/Title.text = SCRIPTURE[index]['Title']
	$Info/TextureRect/Title/Label.text = SCRIPTURE[index]['Brief_Desc']
	$Info/TextureRect/Title/Label/Label.text = SCRIPTURE[index]['Date']
	$Info/TextureRect/Translation_Title/Desc.text = SCRIPTURE[index]['Desc']

	match index:
		0:
			$Info/TextureRect/TextureRect.texture = load("res://graphics/container/fragment1.png")
		1:
			$Info/TextureRect/TextureRect.texture = load("res://graphics/container/fragment2.png")
		2:
			$Info/TextureRect/TextureRect.texture = load("res://graphics/container/fragment3.png")
		3:
			$Info/TextureRect/TextureRect.texture = load("res://graphics/container/fragment4.png")
		4:
			$Info/TextureRect/TextureRect.texture = load("res://graphics/container/fragment5.png")

	$Pop/Overlay/Animation/AnimationPlayer.play("pop_script")
	$Pop/DirectionalLight2D.energy = 3
	while $Pop/DirectionalLight2D.energy > 0:
		await get_tree().create_timer(.06).timeout
		$Pop/DirectionalLight2D.energy -= 1


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	is_skippable = true
