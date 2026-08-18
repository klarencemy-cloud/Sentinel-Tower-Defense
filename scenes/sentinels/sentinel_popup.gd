extends CanvasLayer
var is_skippable: bool = false


# func _ready() -> void:
# 	play_animation(1)

func _on_info_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and is_skippable:
			$Info/AnimationPlayer.play_backwards("pop_info")
			await get_tree().create_timer(0.3).timeout
			is_skippable = false
			var ui = get_tree().get_first_node_in_group("UI")
			ui.hide_pop3(false)
			$Pop/Overlay/Animation.visible = true
			$Info.visible = false
			GameDialogueManager.clicked = 0

	
enum Sentinel {ETHICAL, SYSAD, INTRUSION, SECURITY, MALWARE, DECEPTION}

var SENTINEL_DATA = {
	Sentinel.ETHICAL: {
		'special_ability': "Freezes all the enemies on the field for 3 seconds.",
		'cooldown': 'Cooldown: 15 seconds',
		'passive_ability': "Slows nearby enemies by 25% of their movement speed.",
		'irl_desc': "This is a cybersecurity expert who lawfully intrudes on a computer or network. They have the permission and approval to hack into a certain computing device. Lastly, they usually provide a security assessment to provide a comprehensive way to further improve a system."
	},
		Sentinel.SYSAD: {
		'special_ability': "Repair server health by 3%.",
		'cooldown': "Cooldown: 1 minute and 30 seconds",
		'passive_ability': "Generates gold and EXP periodically for the player.",
		'irl_desc': "Their main role is to provide support, troubleshoot problems, and ensure that the computer infrastructure, such as servers and the network, is functioning."
	},
		Sentinel.INTRUSION: {
		'special_ability': "Deploys a shield with 1500 hit points around the Server that reflects damage to attackers.",
		'cooldown': "Cooldown: 30 seconds",
		'passive_ability': "Reduce damage to the server by 5%.",
		'irl_desc': "An Intrusion Analyst is responsible for detecting, analyzing, and responding to cybersecurity threats or unauthorized access within an organization's computer networks. They monitor network traffic, investigate security incidents, and use specialized tools to identify potential breaches or vulnerabilities. Their work helps prevent data loss and protects sensitive information by quickly addressing and mitigating cyber threats. Additionally, they often collaborate with other IT and security teams to improve overall security posture and may assist in developing security policies and response plans."
	},
		Sentinel.SECURITY: {
		'special_ability': "Increases nearby towers' attack speed by 15% for 10 seconds.",
		'cooldown': "Cooldown: 15 seconds",
		'passive_ability': "Nearby towers gain an additional 25% range. ",
		'irl_desc': "Security Architects design, develop, and implement systems that prevent the infiltration of malware and other hacker-related intrusions across the IT network, thereby helping organisations to continue their activities without encouraging costly and damaging situations."
	},
		Sentinel.MALWARE: {
		'special_ability': "Examines detected threats, reveals their weaknesses, and instead of directly attacking enemies, it improves the effectiveness of other nearby defense towers' damage by 30% for 15 seconds.",
		'cooldown': "Cooldown: 25 seconds",
		'passive_ability': "Nearby towers gain an additional 10% crit chance.  ",
		'irl_desc': "A malware analyst examines malicious files and applications to comprehend how malware operates and how it can be prevented or countered. Their perspectives assist cybersecurity teams in identifying, examining, and protecting against cyber threats. They provide information on malicious software, revealing its function, what it aims for, and how actors utilize it. Additionally, they are also combating malicious software."
	},
		Sentinel.DECEPTION: {
		'special_ability': "Disorient enemies upon approaching the Server for 15 seconds, causing enemies near the Server to change direction.",
		'cooldown': "Cooldown: 30 seconds",
		'passive_ability': "Reduce damage to the server by 5%.",
		'irl_desc': "The Deception Specialist handles deception technology,  which is a strategy to attract cyber criminals away from an enterprise's true assets and divert them to a decoy or trap. The decoy mimics legitimate servers, applications, and data so that the criminal is tricked into believing that they have infiltrated and gained access to the enterprise's most important assets when in reality they have not. The strategy is employed to minimize damage and protect an organization's true assets."
	},
}


func play_animation(sentinel: String):
	var sentinel_name: Label = $Info/TextureRect/Name
	var prototype_code: Label = $Info/TextureRect/Code
	var ability: Label = $Info/TextureRect/Code/Ability
	var cooldown: Label = $Info/TextureRect/Code/Ability/Cooldown
	var passive: Label = $Info/TextureRect/Code/Ability/Cooldown/Passive
	var irl_description: Label = $Info/TextureRect/RealWorldDesc/Desc

	var ui = get_tree().get_first_node_in_group("UI")
	ui.hide_pop3(true)

	match sentinel:
		"Ethical Hacker":
			sentinel_name.text = "Ethical Hacker"
			prototype_code.text = "Prototype: 203232"
			ability.text = SENTINEL_DATA[0]["special_ability"]
			cooldown.text = SENTINEL_DATA[0]["cooldown"]
			passive.text = SENTINEL_DATA[0]["passive_ability"]
			irl_description.text = SENTINEL_DATA[0]["irl_desc"]
		"System Administrator":
			sentinel_name.text = "System Administrator"
			prototype_code.text = "Prototype: 203232"
			ability.text = SENTINEL_DATA[1]["special_ability"]
			cooldown.text = SENTINEL_DATA[1]["cooldown"]
			passive.text = SENTINEL_DATA[1]["passive_ability"]
			irl_description.text = SENTINEL_DATA[1]["irl_desc"]
		"Intrusion Analyst":
			sentinel_name.text = "Intrusion Analyst"
			prototype_code.text = "Prototype: 203232"
			ability.text = SENTINEL_DATA[2]["special_ability"]
			cooldown.text = SENTINEL_DATA[2]["cooldown"]
			passive.text = SENTINEL_DATA[2]["passive_ability"]
			irl_description.text = SENTINEL_DATA[2]["irl_desc"]
		"Security Architect":
			sentinel_name.text = "Security Architect"
			prototype_code.text = "Prototype: 203232"
			ability.text = SENTINEL_DATA[3]["special_ability"]
			cooldown.text = SENTINEL_DATA[3]["cooldown"]
			passive.text = SENTINEL_DATA[3]["passive_ability"]
			irl_description.text = SENTINEL_DATA[3]["irl_desc"]
		"Malware Analyst":
			sentinel_name.text = "Malware Analyst"
			prototype_code.text = "Prototype: 203232"
			ability.text = SENTINEL_DATA[4]["special_ability"]
			cooldown.text = SENTINEL_DATA[4]["cooldown"]
			passive.text = SENTINEL_DATA[4]["passive_ability"]
			irl_description.text = SENTINEL_DATA[4]["irl_desc"]
		"Deception Analyst":
			sentinel_name.text = "Deception Analyst"
			prototype_code.text = "Prototype: 203232"
			ability.text = SENTINEL_DATA[5]["special_ability"]
			cooldown.text = SENTINEL_DATA[5]["cooldown"]
			passive.text = SENTINEL_DATA[5]["passive_ability"]
			irl_description.text = SENTINEL_DATA[5]["irl_desc"]


	$Pop/Overlay/Animation/AnimationPlayer.play("pop_script")
	$Pop/DirectionalLight2D.energy = 3
	while $Pop/DirectionalLight2D.energy > 0:
		await get_tree().create_timer(.06).timeout
		$Pop/DirectionalLight2D.energy -= 1


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	is_skippable = true
