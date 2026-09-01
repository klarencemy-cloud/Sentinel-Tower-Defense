extends CanvasLayer
var is_skippable: bool = false

func _process(delta: float) -> void:
	$Info/TextureRect/Name/Medium_Spinner.rotation += .1
	$Info/TextureRect/Name/Small_Spinner.rotation += .05

func _on_info_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and is_skippable:
			UISound.play_close()
			$Info/AnimationPlayer.play_backwards("pop_info")
			await get_tree().create_timer(0.3).timeout
			is_skippable = false
			var ui = get_tree().get_first_node_in_group("UI")
			ui.hide_pop4(false)
			$Pop/Overlay/Animation.visible = true
			$Info.visible = false
			GameDialogueManager.clicked = 0
			GameDialogueManager.pause_game(false)

var towers_name: Array = [
	"Antivirus",
	"Adblocker",
	"DLP (Data Loss Prevention) ",
	"Intrusion Detection and Prevention System",
	"Quarantine Cannon",
	"Access Control System",
	"AI Security",
	"Endpoint Protection",
	"Sandbox Analyzer",
	]

enum Tower {ANTIVIRUS, ADBLOCKER, DLP, IDPS, QUARANTINE_CANNON, ACS, AI_SECURITY, ENDPOINT, SANDBOX}

var TOWER_DATA = {
	Tower.ANTIVIRUS: {
		'damage': "30",
		'atk_speed': "1.00",
		'type': "Bullet",
		'special_ability': "Deals increased damage to malware enemies such as Viruses, Worms, and Trojan horses.",
		'irl_desc': "Antivirus protection refers to software designed to monitor, detect, prevent, and eliminate malicious threats before they infect, corrupt, or entirely damage data or devices. The threats include software viruses and malware, such as worms, ransomware, and more. For this, it monitors and scans incoming data from the internet, including emails, websites, and external devices like hard drives, helping identify network security vulnerabilities that malware could exploit."
	},
	Tower.ADBLOCKER: {
		'damage': "40",
		'atk_speed': "0.75",
		'type': "Area",
		'special_ability': "Automatically removes the disable effect caused by Adware. Deals bonus damage to Adware. ",
		'irl_desc': "Adblock technology makes use of straightforward lists, known as filter lists, to decide what should be hidden or blocked from appearing on the pages a user visits."
	},
	Tower.DLP: {
		'damage': "0",
		'atk_speed': "1.50",
		'type': "Bullet",
		'special_ability': "Infects enemies and reduces their damage by 50%. ",
		'irl_desc': "Data Loss Prevention classifies sensitive data to prevent unauthorized users from stealing or misusing proprietary information. The technology monitors data across endpoints, networks, and cloud storage, immediately stopping violations like uploading customer PII (Personally Identifiable Information), corporate secrets, or financial records to personal drives, enforcing corporate compliance mandates, tracking unauthorized file sharing, preventing accidental leaks by distracted employees, and securing intellectual assets. "
	},
		Tower.IDPS: {
		'damage': "75",
		'atk_speed': "1.00",
		'type': "Area",
		'special_ability': "Reveals stealth enemies, allowing all towers to target them.",
		'irl_desc': "An Intrusion Detection System (IDS) and an Intrusion Prevention System (IPS) are cybersecurity technologies that work together, often combined as an Intrusion Detection and Prevention System (IDPS), to identify and block malicious activity in networks. They are essential for safeguarding networks from cyber threats such as malware, intrusions, and denial-of-service attacks."
	},
		Tower.QUARANTINE_CANNON: {
		'damage': "100",
		'atk_speed': "2.00",
		'type': "Splash",
		'special_ability': "Freezes enemies and slows them after thawing.",
		'irl_desc': "It is the separation, isolation, or restriction of certain files or programs from others to stop the spread of malicious intent or damage."
	},
		Tower.ACS: {
		'damage': "120",
		'atk_speed': "1.30",
		'type': "Area",
		'special_ability': "Slows enemies and deals bonus damage to Insider Threats.",
		'irl_desc': "It is a security system known as an access control system that is aimed at restricting and regulating employee access to specific locations or levels within a facility or system. It uses multiple verification methods, including personal identification numbers, cards, tokens, fingerprints, or iris recognition, to either allow or block access."
	},
	Tower.AI_SECURITY: {
		'damage': "130",
		'atk_speed': "N/A",
		'type': "Bullet",
		'special_ability': "It eliminates the enemies using a laser. The laser will continuously hit the enemy and provide damage until it is eliminated.",
		'irl_desc': "AI security is the process of using AI to enhance an organization's security posture. With AI systems, organizations can automate threat detection, prevention, and remediation to better combat cyberattacks and data breaches."
	},
	Tower.ENDPOINT: {
		'damage': "180",
		'atk_speed': "1.25",
		'type': "Area",
		'special_ability': "Grants immunity to malware debuffs to two selected towers.",
		'irl_desc': "Endpoint protection involves monitoring and protecting endpoints against cyber threats. Protected endpoints include desktops, laptops, smartphones, tablet computers, and other devices. Various cybersecurity solutions can be installed on and monitor these devices to protect them against cyber threats, regardless of where they are located on or off the corporate network."
	},
	Tower.SANDBOX: {
		'damage': "220",
		'atk_speed': "3.00",
		'type': "Bullet",
		'special_ability': "Traps one enemy in a force cage until it dies, but it cannot target another enemy while occupied. Nearby enemies become infected as well. ",
		'irl_desc': "Suspicious files or links execute safely within this isolated virtual environment without risking production infrastructure. The environment records internal process behaviors, keeping an eye out for registry modifications, hidden logic bombs, and sleeper malware, flagging the file if malicious actions are observed, which provides analysts with highly detailed threat intelligence about completely unclassified zero-day exploits before they ever touch physical hard drives. "
	},
}


func play_animation(tower: String):
	GameDialogueManager.pause_game(true)
	var tower_name: Label = $Info/TextureRect/Name
	var damage: Label = $Info/TextureRect/Name/Damage
	var type: Label = $Info/TextureRect/Name/Type
	var speed: Label = $Info/TextureRect/Name/Speed
	var special: Label = $Info/TextureRect/Name/Special
	var irl_description: Label = $Info/TextureRect/RealWorldDesc/Desc

	var ui = get_tree().get_first_node_in_group("UI")
	ui.hide_pop4(true)

	match tower:
		"antivirus":
			tower_name.text = towers_name[0]
			damage.text = TOWER_DATA[0]["damage"]
			type.text = TOWER_DATA[0]["type"]
			speed.text = TOWER_DATA[0]["atk_speed"]
			special.text = TOWER_DATA[0]["special_ability"]
			irl_description.text = TOWER_DATA[0]["irl_desc"]

			ui.unlock_tower_card(1)
		"adblocker":
			tower_name.text = towers_name[1]
			damage.text = TOWER_DATA[1]["damage"]
			type.text = TOWER_DATA[1]["type"]
			speed.text = TOWER_DATA[1]["atk_speed"]
			special.text = TOWER_DATA[1]["special_ability"]
			irl_description.text = TOWER_DATA[1]["irl_desc"]
		"dlp":
			tower_name.text = towers_name[2]
			damage.text = TOWER_DATA[2]["damage"]
			type.text = TOWER_DATA[2]["type"]
			speed.text = TOWER_DATA[2]["atk_speed"]
			special.text = TOWER_DATA[2]["special_ability"]
			irl_description.text = TOWER_DATA[2]["irl_desc"]
		"idps":
			tower_name.text = towers_name[3]
			damage.text = TOWER_DATA[3]["damage"]
			type.text = TOWER_DATA[3]["type"]
			speed.text = TOWER_DATA[3]["atk_speed"]
			special.text = TOWER_DATA[3]["special_ability"]
			irl_description.text = TOWER_DATA[3]["irl_desc"]
		"qcannon":
			tower_name.text = towers_name[4]
			damage.text = TOWER_DATA[4]["damage"]
			type.text = TOWER_DATA[4]["type"]
			speed.text = TOWER_DATA[4]["atk_speed"]
			special.text = TOWER_DATA[4]["special_ability"]
			irl_description.text = TOWER_DATA[4]["irl_desc"]
		"acs":
			tower_name.text = towers_name[5]
			damage.text = TOWER_DATA[5]["damage"]
			type.text = TOWER_DATA[5]["type"]
			speed.text = TOWER_DATA[5]["atk_speed"]
			special.text = TOWER_DATA[5]["special_ability"]
			irl_description.text = TOWER_DATA[5]["irl_desc"]
		"ai":
			tower_name.text = towers_name[6]
			damage.text = TOWER_DATA[6]["damage"]
			type.text = TOWER_DATA[6]["type"]
			speed.text = TOWER_DATA[6]["atk_speed"]
			special.text = TOWER_DATA[6]["special_ability"]
			irl_description.text = TOWER_DATA[6]["irl_desc"]
		"epprotection":
			tower_name.text = towers_name[7]
			damage.text = TOWER_DATA[7]["damage"]
			type.text = TOWER_DATA[7]["type"]
			speed.text = TOWER_DATA[7]["atk_speed"]
			special.text = TOWER_DATA[7]["special_ability"]
			irl_description.text = TOWER_DATA[7]["irl_desc"]
		"sandbox":
			tower_name.text = towers_name[8]
			damage.text = TOWER_DATA[8]["damage"]
			type.text = TOWER_DATA[8]["type"]
			speed.text = TOWER_DATA[8]["atk_speed"]
			special.text = TOWER_DATA[8]["special_ability"]
			irl_description.text = TOWER_DATA[8]["irl_desc"]
	$Info/TextureRect/AnimatedSprite2D.play(tower)
	$Pop/AnimationPlayer.play("pop_tower")
	$Pop/DirectionalLight2D.energy = 3
	while $Pop/DirectionalLight2D.energy > 0:
		await get_tree().create_timer(.06).timeout
		$Pop/DirectionalLight2D.energy -= 1


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	is_skippable = true
