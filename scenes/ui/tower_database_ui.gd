extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_refresh_tower_image_states()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var parent_size = $ScrollBarContainer/Bar.size
	var scroll_size = $ScrollBarContainer/Bar/Scroll.size
	$ScrollBarContainer/Bar/Scroll.position.x = clamp(
		$ScrollBarContainer/Bar.position.x,
		8.5,
		8.5
	)
	$ScrollBarContainer/Bar/Scroll.position.y = clamp(
		$ScrollBarContainer/Bar/Scroll.position.y,
		13,
		700
	)
	
	var tower_container_size = $TowerContainer.size
	var card_container_size = $TowerContainer/CardContainer.size
	$TowerContainer/CardContainer.position.x = clamp(
		$TowerContainer/CardContainer.position.x,
		0,
		0
	)
	$TowerContainer/CardContainer.position.y = clamp(
		$TowerContainer/CardContainer.position.y,
		-545,
		11
	)

var dragging = false
func _on_texture_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position += event.relative
		$TowerContainer/CardContainer.position -= event.relative
		

func _on_card_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position += event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
			
func _on_tower_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position += event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
				

func _on_tower_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position += event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position += event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_4_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position += event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_5_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position += event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_6_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position += event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_7_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position += event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_8_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position += event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_9_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position += event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_tower_10_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $TowerContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative
		$TowerContainer/CardContainer.position += event.relative
		for child in $TowerContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


var tower_name: Array = [
	"Spam Filter",
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

enum Tower {SPAM, ANTIVIRUS, ADBLOCKER, DLP, IDPS, QUARANTINE_CANNON, ACS, AI_SECURITY, ENDPOINT, SANDBOX}

var TOWER_DATA = {
	Tower.SPAM: {
		'damage': Data.TOWER_DATA[0]["damage"],
		'atk_speed': Data.TOWER_DATA[0]["reload_time"],
		'type': "Bullet",
		'special_ability': "Attacks bounce to nearby enemies. Deals bonus damage to Spam",
		'irl_desc': "These are automated security tools that are used to identify, block, redirect, or allow bulk, unwanted, or malicious emails before it reaches the primary inbox of a user's email.",
		'thumbnail': "res://graphics/ui/tower thumbnails 2/SPAM_FILTER.png"
	},
	Tower.ANTIVIRUS: {
		'damage': Data.TOWER_DATA[1]["damage"],
		'atk_speed': Data.TOWER_DATA[1]["reload_time"],
		'type': "Bullet",
		'special_ability': "Deals increased damage to malware enemies such as Viruses, Worms, and Trojan horses.",
		'irl_desc': "Antivirus protection refers to software designed to monitor, detect, prevent, and eliminate malicious threats before they infect, corrupt, or entirely damage data or devices. The threats include software viruses and malware, such as worms, ransomware, and more. For this, it monitors and scans incoming data from the internet, including emails, websites, and external devices like hard drives, helping identify network security vulnerabilities that malware could exploit.",
		'thumbnail': "res://graphics/ui/tower thumbnails 2/ANTIVIRUS.png"
	},
	Tower.ADBLOCKER: {
		'damage': Data.TOWER_DATA[2]["damage"],
		'atk_speed': Data.TOWER_DATA[2]["reload_time"],
		'type': "Area",
		'special_ability': "Automatically removes the disable effect caused by Adware. Deals bonus damage to Adware. ",
		'irl_desc': "Adblock technology makes use of straightforward lists, known as filter lists, to decide what should be hidden or blocked from appearing on the pages a user visits.",
		'thumbnail': "res://graphics/ui/tower thumbnails 2/ADBLOCKER.png"
	},
	Tower.DLP: {
		'damage': Data.TOWER_DATA[3]["damage"],
		'atk_speed': Data.TOWER_DATA[3]["reload_time"],
		'type': "Bullet",
		'special_ability': "Infects enemies and reduces their damage by 50%. ",
		'irl_desc': "Data Loss Prevention classifies sensitive data to prevent unauthorized users from stealing or misusing proprietary information. The technology monitors data across endpoints, networks, and cloud storage, immediately stopping violations like uploading customer PII (Personally Identifiable Information), corporate secrets, or financial records to personal drives, enforcing corporate compliance mandates, tracking unauthorized file sharing, preventing accidental leaks by distracted employees, and securing intellectual assets. ",
		'thumbnail': "res://graphics/ui/tower thumbnails 2/DLP.png"
	},
		Tower.IDPS: {
		'damage': Data.TOWER_DATA[4]["damage"],
		'atk_speed': Data.TOWER_DATA[4]["reload_time"],
		'type': "Area",
		'special_ability': "Reveals stealth enemies, allowing all towers to target them.",
		'irl_desc': "An Intrusion Detection System (IDS) and an Intrusion Prevention System (IPS) are cybersecurity technologies that work together, often combined as an Intrusion Detection and Prevention System (IDPS), to identify and block malicious activity in networks. They are essential for safeguarding networks from cyber threats such as malware, intrusions, and denial-of-service attacks.",
		'thumbnail': "res://graphics/ui/tower thumbnails 2/IDPS.png"
	},
		Tower.QUARANTINE_CANNON: {
		'damage': Data.TOWER_DATA[5]["damage"],
		'atk_speed': Data.TOWER_DATA[5]["reload_time"],
		'type': "Splash",
		'special_ability': "Freezes enemies and slows them after thawing.",
		'irl_desc': "It is the separation, isolation, or restriction of certain files or programs from others to stop the spread of malicious intent or damage.",
		'thumbnail': "res://graphics/ui/tower thumbnails 2/QUARANTINE.png"
	},
		Tower.ACS: {
		'damage': Data.TOWER_DATA[6]["damage"],
		'atk_speed': Data.TOWER_DATA[6]["reload_time"],
		'type': "Area",
		'special_ability': "Slows enemies and deals bonus damage to Insider Threats.",
		'irl_desc': "It is a security system known as an access control system that is aimed at restricting and regulating employee access to specific locations or levels within a facility or system. It uses multiple verification methods, including personal identification numbers, cards, tokens, fingerprints, or iris recognition, to either allow or block access.",
		'thumbnail': "res://graphics/ui/tower thumbnails 2/ACS.png"
	},
	Tower.AI_SECURITY: {
		'damage': Data.TOWER_DATA[7]["damage"],
		'atk_speed': "N/A",
		'type': "Bullet",
		'special_ability': "It eliminates the enemies using a laser. The laser will continuously hit the enemy and provide damage until it is eliminated.",
		'irl_desc': "AI security is the process of using AI to enhance an organization's security posture. With AI systems, organizations can automate threat detection, prevention, and remediation to better combat cyberattacks and data breaches.",
		'thumbnail': "res://graphics/ui/tower thumbnails 2/AI_SEC.png"
	},
	Tower.ENDPOINT: {
		'damage': Data.TOWER_DATA[9]["damage"],
		'atk_speed': Data.TOWER_DATA[9]["reload_time"],
		'type': "Area",
		'special_ability': "Grants immunity to malware debuffs to two selected towers.",
		'irl_desc': "Endpoint protection involves monitoring and protecting endpoints against cyber threats. Protected endpoints include desktops, laptops, smartphones, tablet computers, and other devices. Various cybersecurity solutions can be installed on and monitor these devices to protect them against cyber threats, regardless of where they are located on or off the corporate network.",
		'thumbnail': "res://graphics/ui/tower thumbnails 2/ENDPOINT_PROTECTION.png"
	},
	Tower.SANDBOX: {
		'damage': Data.TOWER_DATA[10]["damage"],
		'atk_speed': Data.TOWER_DATA[10]["reload_time"],
		'type': "Bullet",
		'special_ability': "Traps one enemy in a force cage until it dies, but it cannot target another enemy while occupied. Nearby enemies become infected as well. ",
		'irl_desc': "Suspicious files or links execute safely within this isolated virtual environment without risking production infrastructure. The environment records internal process behaviors, keeping an eye out for registry modifications, hidden logic bombs, and sleeper malware, flagging the file if malicious actions are observed, which provides analysts with highly detailed threat intelligence about completely unclassified zero-day exploits before they ever touch physical hard drives. ",
		'thumbnail': "res://graphics/ui/tower thumbnails 2/SANDBOX.png"
	},
}


@onready var desc_name: Label = $Databasebg/Name
@onready var desc_damage: Label = $Databasebg/Damage
@onready var desc_speed: Label = $Databasebg/Speed
@onready var desc_type: Label = $Databasebg/Type
@onready var desc_sp: Label = $Databasebg/Special
@onready var desc_desc: Label = $Databasebg/Special/RealLifeDesc/Description

	
func _refresh_tower_image_states() -> void:
	var tower_map := {
		1: Data.Tower.SPAM_FILTER,
		2: Data.Tower.ANTIVIRUS,
		3: Data.Tower.AD_BLOCKER,
		4: Data.Tower.DATA_LOSS_PREVENTION,
		5: Data.Tower.IDPS,
		6: Data.Tower.QUARANTINE_CANNON,
		7: Data.Tower.ACCESS_CONTROL_SYSTEM,
		8: Data.Tower.AI_SECURITY,
		9: Data.Tower.ENDPOINT_PROTECTION,
		10: Data.Tower.SANDBOX_ANALYZER,
	}

	for card_index in tower_map.keys():
		var button_path := "TowerContainer/CardContainer/Tower%d" % card_index
		var button: TextureButton = get_node_or_null(button_path)
		if button == null:
			continue

		var image: TextureRect = button.get_node_or_null("TextureRect")
		# var name_label: Label = button.get_node_or_null("Tower_Name_%d" % card_index)

		var is_unlocked := is_tower_unlocked(tower_map[card_index])

		if image:
			image.modulate = Color(1, 1, 1, 1) if is_unlocked else Color(0, 0, 0, 1)

		# if name_label:
		# 	name_label.text = tower_name[card_index - 1] if is_unlocked else "???"


func _on_tower_1_pressed() -> void:
	UISound.play_click()
	if not is_tower_unlocked(Data.Tower.SPAM_FILTER):
		desc_name.text = "???"
		desc_damage.text = "???"
		desc_speed.text = "???"
		desc_type.text = "???"
		desc_sp.text = "Attack Descrption: Unknown"
		desc_desc.text = "No Available Data"
		$Databasebg/AnimatedSprite2D.visible = true
		$Databasebg/AnimatedSprite2D.modulate = Color(0, 0, 0, 1)
		$Databasebg/AnimatedSprite2D.play("spam")
		return

	desc_name.text = tower_name[0]
	desc_damage.text = str(TOWER_DATA[0]['damage'])
	desc_speed.text = str(TOWER_DATA[0]['atk_speed'])
	desc_type.text = str(TOWER_DATA[0]['type'])
	desc_sp.text = str(TOWER_DATA[0]['special_ability'])
	desc_desc.text = str(TOWER_DATA[0]['irl_desc'])
	$Databasebg/AnimatedSprite2D.visible = true
	$Databasebg/AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	$Databasebg/AnimatedSprite2D.play("spam")


func _on_tower_2_pressed() -> void:
	UISound.play_click()
	if not is_tower_unlocked(Data.Tower.ANTIVIRUS):
		desc_name.text = "???"
		desc_damage.text = "???"
		desc_speed.text = "???"
		desc_type.text = "???"
		desc_sp.text = "Attack Descrption: Unknown"
		desc_desc.text = "No Available Data"
		$Databasebg/AnimatedSprite2D.visible = true
		$Databasebg/AnimatedSprite2D.modulate = Color(0, 0, 0, 1)
		$Databasebg/AnimatedSprite2D.play("antivirus")
		return

	desc_name.text = tower_name[1]
	desc_damage.text = str(TOWER_DATA[1]['damage'])
	desc_speed.text = str(TOWER_DATA[1]['atk_speed'])
	desc_type.text = str(TOWER_DATA[1]['type'])
	desc_sp.text = str(TOWER_DATA[1]['special_ability'])
	desc_desc.text = str(TOWER_DATA[1]['irl_desc'])
	$Databasebg/AnimatedSprite2D.visible = true
	$Databasebg/AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	$Databasebg/AnimatedSprite2D.play("antivirus")


func _on_tower_3_pressed() -> void:
	UISound.play_click()
	if not is_tower_unlocked(Data.Tower.AD_BLOCKER):
		desc_name.text = "???"
		desc_damage.text = "???"
		desc_speed.text = "???"
		desc_type.text = "???"
		desc_sp.text = "Attack Descrption: Unknown"
		desc_desc.text = "No Available Data"
		$Databasebg/AnimatedSprite2D.visible = true
		$Databasebg/AnimatedSprite2D.modulate = Color(0, 0, 0, 1)
		$Databasebg/AnimatedSprite2D.play("adblocker")
		return

	desc_name.text = tower_name[2]
	desc_damage.text = str(TOWER_DATA[2]['damage'])
	desc_speed.text = str(TOWER_DATA[2]['atk_speed'])
	desc_type.text = str(TOWER_DATA[2]['type'])
	desc_sp.text = str(TOWER_DATA[2]['special_ability'])
	desc_desc.text = str(TOWER_DATA[2]['irl_desc'])
	$Databasebg/AnimatedSprite2D.visible = true
	$Databasebg/AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	$Databasebg/AnimatedSprite2D.play("adblocker")


func _on_tower_4_pressed() -> void:
	UISound.play_click()
	if not is_tower_unlocked(Data.Tower.DATA_LOSS_PREVENTION):
		desc_name.text = "???"
		desc_damage.text = "???"
		desc_speed.text = "???"
		desc_type.text = "???"
		desc_sp.text = "Attack Descrption: Unknown"
		desc_desc.text = "No Available Data"
		$Databasebg/AnimatedSprite2D.visible = true
		$Databasebg/AnimatedSprite2D.modulate = Color(0, 0, 0, 1)
		$Databasebg/AnimatedSprite2D.play("dlp")
		return

	desc_name.text = tower_name[3]
	desc_damage.text = str(TOWER_DATA[3]['damage'])
	desc_speed.text = str(TOWER_DATA[3]['atk_speed'])
	desc_type.text = str(TOWER_DATA[3]['type'])
	desc_sp.text = str(TOWER_DATA[3]['special_ability'])
	desc_desc.text = str(TOWER_DATA[3]['irl_desc'])
	$Databasebg/AnimatedSprite2D.visible = true
	$Databasebg/AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	$Databasebg/AnimatedSprite2D.play("dlp")


func _on_tower_5_pressed() -> void:
	UISound.play_click()
	if not is_tower_unlocked(Data.Tower.IDPS):
		desc_name.text = "???"
		desc_damage.text = "???"
		desc_speed.text = "???"
		desc_type.text = "???"
		desc_sp.text = "Attack Descrption: Unknown"
		desc_desc.text = "No Available Data"
		$Databasebg/AnimatedSprite2D.visible = true
		$Databasebg/AnimatedSprite2D.modulate = Color(0, 0, 0, 1)
		$Databasebg/AnimatedSprite2D.play("idps")
		return

	desc_name.text = tower_name[4]
	desc_damage.text = str(TOWER_DATA[4]['damage'])
	desc_speed.text = str(TOWER_DATA[4]['atk_speed'])
	desc_type.text = str(TOWER_DATA[4]['type'])
	desc_sp.text = str(TOWER_DATA[4]['special_ability'])
	desc_desc.text = str(TOWER_DATA[4]['irl_desc'])
	$Databasebg/AnimatedSprite2D.visible = true
	$Databasebg/AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	$Databasebg/AnimatedSprite2D.play("idps")


func _on_tower_6_pressed() -> void:
	UISound.play_click()
	if not is_tower_unlocked(Data.Tower.QUARANTINE_CANNON):
		desc_name.text = "???"
		desc_damage.text = "???"
		desc_speed.text = "???"
		desc_type.text = "???"
		desc_sp.text = "Attack Descrption: Unknown"
		desc_desc.text = "No Available Data"
		$Databasebg/AnimatedSprite2D.visible = true
		$Databasebg/AnimatedSprite2D.modulate = Color(0, 0, 0, 1)
		$Databasebg/AnimatedSprite2D.play("qcannon")
		return

	desc_name.text = tower_name[5]
	desc_damage.text = str(TOWER_DATA[5]['damage'])
	desc_speed.text = str(TOWER_DATA[5]['atk_speed'])
	desc_type.text = str(TOWER_DATA[5]['type'])
	desc_sp.text = str(TOWER_DATA[5]['special_ability'])
	desc_desc.text = str(TOWER_DATA[5]['irl_desc'])
	$Databasebg/AnimatedSprite2D.visible = true
	$Databasebg/AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	$Databasebg/AnimatedSprite2D.play("qcannon")


func _on_tower_7_pressed() -> void:
	UISound.play_click()
	if not is_tower_unlocked(Data.Tower.ACCESS_CONTROL_SYSTEM):
		desc_name.text = "???"
		desc_damage.text = "???"
		desc_speed.text = "???"
		desc_type.text = "???"
		desc_sp.text = "Attack Descrption: Unknown"
		desc_desc.text = "No Available Data"
		$Databasebg/AnimatedSprite2D.visible = true
		$Databasebg/AnimatedSprite2D.modulate = Color(0, 0, 0, 1)
		$Databasebg/AnimatedSprite2D.play("acs")
		return

	desc_name.text = tower_name[6]
	desc_damage.text = str(TOWER_DATA[6]['damage'])
	desc_speed.text = str(TOWER_DATA[6]['atk_speed'])
	desc_type.text = str(TOWER_DATA[6]['type'])
	desc_sp.text = str(TOWER_DATA[6]['special_ability'])
	desc_desc.text = str(TOWER_DATA[6]['irl_desc'])
	$Databasebg/AnimatedSprite2D.visible = true
	$Databasebg/AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	$Databasebg/AnimatedSprite2D.play("acs")


func _on_tower_8_pressed() -> void:
	UISound.play_click()
	if not is_tower_unlocked(Data.Tower.AI_SECURITY):
		desc_name.text = "???"
		desc_damage.text = "???"
		desc_speed.text = "???"
		desc_type.text = "???"
		desc_sp.text = "Attack Descrption: Unknown"
		desc_desc.text = "No Available Data"
		$Databasebg/AnimatedSprite2D.visible = true
		$Databasebg/AnimatedSprite2D.modulate = Color(0, 0, 0, 1)
		$Databasebg/AnimatedSprite2D.play("aisec")
		return

	desc_name.text = tower_name[7]
	desc_damage.text = str(TOWER_DATA[7]['damage'])
	desc_speed.text = str(TOWER_DATA[7]['atk_speed'])
	desc_type.text = str(TOWER_DATA[7]['type'])
	desc_sp.text = str(TOWER_DATA[7]['special_ability'])
	desc_desc.text = str(TOWER_DATA[7]['irl_desc'])
	$Databasebg/AnimatedSprite2D.visible = true
	$Databasebg/AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	$Databasebg/AnimatedSprite2D.play("aisec")


func _on_tower_9_pressed() -> void:
	UISound.play_click()
	if not is_tower_unlocked(Data.Tower.ENDPOINT_PROTECTION):
		desc_name.text = "???"
		desc_damage.text = "???"
		desc_speed.text = "???"
		desc_type.text = "???"
		desc_sp.text = "Attack Descrption: Unknown"
		desc_desc.text = "No Available Data"
		$Databasebg/AnimatedSprite2D.visible = true
		$Databasebg/AnimatedSprite2D.modulate = Color(0, 0, 0, 1)
		$Databasebg/AnimatedSprite2D.play("epprotection")
		return

	desc_name.text = tower_name[8]
	desc_damage.text = str(TOWER_DATA[8]['damage'])
	desc_speed.text = str(TOWER_DATA[8]['atk_speed'])
	desc_type.text = str(TOWER_DATA[8]['type'])
	desc_sp.text = str(TOWER_DATA[8]['special_ability'])
	desc_desc.text = str(TOWER_DATA[8]['irl_desc'])
	$Databasebg/AnimatedSprite2D.visible = true
	$Databasebg/AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	$Databasebg/AnimatedSprite2D.play("epprotection")


func _on_tower_10_pressed() -> void:
	UISound.play_click()
	if not is_tower_unlocked(Data.Tower.SANDBOX_ANALYZER):
		desc_name.text = "???"
		desc_damage.text = "???"
		desc_speed.text = "???"
		desc_type.text = "???"
		desc_sp.text = "Attack Descrption: Unknown"
		desc_desc.text = "No Available Data"
		$Databasebg/AnimatedSprite2D.visible = true
		$Databasebg/AnimatedSprite2D.modulate = Color(0, 0, 0, 1)
		$Databasebg/AnimatedSprite2D.play("sbanalyzer")
		return

	desc_name.text = tower_name[9]
	desc_damage.text = str(TOWER_DATA[9]['damage'])
	desc_speed.text = str(TOWER_DATA[9]['atk_speed'])
	desc_type.text = str(TOWER_DATA[9]['type'])
	desc_sp.text = str(TOWER_DATA[9]['special_ability'])
	desc_desc.text = str(TOWER_DATA[9]['irl_desc'])
	$Databasebg/AnimatedSprite2D.visible = true
	$Databasebg/AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	$Databasebg/AnimatedSprite2D.play("sbanalyzer")


func is_tower_unlocked(tower_enum: Data.Tower) -> bool:
	return Data.TOWER_DATA[tower_enum].get("isUnlocked", false)


func refresh_tower_unlock_visuals() -> void:
	_refresh_tower_image_states()
