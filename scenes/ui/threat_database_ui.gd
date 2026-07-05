extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
		745
	)
	
	var threat_container_size = $ThreatContainer.size
	var card_container_size = $ThreatContainer/CardContainer.size
	$ThreatContainer/CardContainer.position.x = clamp(
		$ThreatContainer/CardContainer.position.x,
		0,
		0
	)
	$ThreatContainer/CardContainer.position.y = clamp(
		$ThreatContainer/CardContainer.position.y,
		-1939.0,
		11
	)
	
var dragging = false


func _on_scroll_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position += event.relative
		$ThreatContainer/CardContainer.position -= event.relative * 2.5


func _on_card_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative / 2.5
		$ThreatContainer/CardContainer.position += event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
				

func _on_threat_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative / 2.5
		$ThreatContainer/CardContainer.position += event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative / 2.5
		$ThreatContainer/CardContainer.position += event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative / 2.5
		$ThreatContainer/CardContainer.position += event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_4_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative / 2.5
		$ThreatContainer/CardContainer.position += event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_5_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative / 2.5
		$ThreatContainer/CardContainer.position += event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_6_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative / 2.5
		$ThreatContainer/CardContainer.position += event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_7_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative / 2.5
		$ThreatContainer/CardContainer.position += event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_8_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative / 2.5
		$ThreatContainer/CardContainer.position += event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_9_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative / 2.5
		$ThreatContainer/CardContainer.position += event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_threat_10_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if event.pressed == false:
				for child in $ThreatContainer/CardContainer.get_children():
					if child is TextureButton:
						child.mouse_filter = Control.MOUSE_FILTER_STOP
						
	elif event is InputEventMouseMotion and dragging:
		$ScrollBarContainer/Bar/Scroll.position -= event.relative / 2.5
		$ThreatContainer/CardContainer.position += event.relative
		for child in $ThreatContainer/CardContainer.get_children():
			if child is TextureButton:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


var threat_name: Array = [
	"Spam",
	"Virus",
	"Adware",
	"Worm",
	"Spyware",
	"Botnet Node",
	"Credential Stuffing",
	"Trojan Horse",
	"Insider Threat",
	"Rootkit",
	"SQL Injection",
	"DDoS",
	"Ransomware",
	"Zero-Day",
	"ILOVEYOU Virus",
	"Conficker",
	"WannaCry",
	"Notpetya",
	"My Doom",
	"TROJAN"
	]

	
enum Threat {SPAM, VIRUS, ADWARE, WORM, SPYWARE, BOTNET, CREDS, TROJAN_HORSE, INSIDER, ROOTKIT, SQL, DDOS, RANSOMWARE, ZERO, ILOVEYOU, CONFICKER, WANNACRY, NOTPETYA, DOOM, TROJAN}

var THREAT_DATA = {
	Threat.SPAM: {
		'health': 20,
		'damage': 5,
		'speed': 105,
		'special_ability': "They spawn in swarms or in groups, making towers less efficient as they come in groups.",
		'irl_desc': "Spam is unsolicited, unwelcome digital communication that is transmitted in large quantities, mostly via email but sometimes via texts, phone calls, and social media."
	},
	Threat.VIRUS: {
		'health': 40,
		'damage': 40,
		'speed': 100,
		'special_ability': "It debuffs towers and corrupts data (damage) in the server.",
		'irl_desc': "A computer virus is a malicious software program or code that can attach itself to files and programs and replicate itself. It can also spread to other devices. When it is activated, the virus modifies other software by embedding its code within the file. And, if the virus successfully replicates itself, the device is considered infected with a computer virus. Additionally, the harmful actions performed by the virus code can damage the local file system, steal data, disrupt services, download additional malware, or execute any other tasks that the malicious actor programmed into the software. Numerous viruses are disguised as legitimate programs to deceive users into running them on their devices, thus delivering the computer virus payload into their system."
		},
	Threat.ADWARE: {
		'health': 80,
		'damage': 12,
		'speed': 105,
		'special_ability': "This makes a tower unavailable; the player must click or tap the tower to make it available again.",
		'irl_desc': "Adware is any program that shows users online advertisements for the developer to make money. These can be in the form of pop-ups, messages, new browser windows, or new browser tabs."
		},
	Threat.WORM: {
		'health': 30,
		'damage': 15,
		'speed': 120,
		'special_ability': "It deals little damage, and it replicates itself as long as it is alive.",
		'irl_desc': "A worm is a type of malicious software that spreads quickly among devices connected to a network. A worm uses a bandwidth as it spreads, then it overwhelms the compromised systems, hence leaving them unavailable or unreliable. Additionally, worms can add additional malware or modify and delete files."
		},
		Threat.SPYWARE: {
		'health': 100,
		'damage': 35,
		'speed': 115,
		'special_ability': "Infects the tower, reducing its range, and it increases enemy speed and damage to the enemies nearby.",
		'irl_desc': "Spyware is a type of software that unethically, without proper permissions or authorization, steals a user's personal or business information and sends it to a third party."
		},

		Threat.BOTNET: {
		'health': 200,
		'damage': 55,
		'speed': 105,
		'special_ability': "Infects then control towers to malfunction, causing them to fire inaccurately or in different directions.",
		'irl_desc': "Botnets are networks of hijacked computer devices used to carry out various scams and cyberattacks. The term “botnet” is formed from the words “robot” and “network.” The assembly of a botnet is usually the infiltration stage of a multi-layer scheme. The bots serve as a tool to automate mass attacks, such as data theft, server crashing, and malware distribution."
		},
	
		Threat.CREDS: {
		'health': "N/A",
		'damage': "N/A",
		'speed': "N/A",
		'special_ability': "Copies the ability of a near enemy and uses it",
		'irl_desc': "Credential stuffing is a cyberattack that uses stolen login credentials from one breach to gain access to accounts on other services."
		},

		Threat.TROJAN_HORSE: {
		'health': 350,
		'damage': 40,
		'speed': 110,
		'special_ability': "Appears as a friendly unit at first, but when it is near a defense tower, it reveals itself and rushes to attack (increase in speed).",
		'irl_desc': "Trojan horse attacks deceive people into running programs that appear to be trusted and safe but are actually malicious by using social engineering and deception. Trojans are programs that appear as attachments, downloads, or video downloads, or programs that pretend to do one thing but actually do another thing maliciously."
		},
	
	Threat.INSIDER: {
		'health': 120,
		'damage': 80,
		'speed': 110,
		'special_ability': "Has the ability to be invisible",
		'irl_desc': "An insider threat occurs when an individual exploits their permitted access to harm a company's essential information or systems. This individual does not have to be an employee; it can be third-party vendors, contractors, and partners."
		},
	Threat.ROOTKIT: {
		'health': 200,
		'damage': 100,
		'speed': 110,
		'special_ability': "Digs a route underground, bypassing a tower that can also be used by the other enemies. The route can only be used in one wave.",
		'irl_desc': "A rootkit is a type of malicious software used to obtain and maintain privileged access to a computer or system, while hiding its presence and activities from the system’s legitimate users, system administrators, and other security mechanisms. Rootkits are highly appealing for threat actors as they can operate deep in the system, allowing them to execute high-privileged commands and operations"
		},
	Threat.SQL: {
		'health': 150,
		'damage': 120,
		'speed': 118,
		'special_ability': "Exploits weaknesses in the network that bypass or jump security checkpoints and advance closer to the server. ",
		'irl_desc': "Also known as SQLI, it is an attack that is aimed at accessing and modifying the backend database where data should not be displayed to unauthorized people."
		},
	Threat.DDOS: {
		'health': 500 - 20,
		'damage': 150,
		'speed': 100,
		'special_ability': "A group of DoS that combine and work together to form a larger entity, then split back when their health drops, making them individually weaker and easier to eliminate",
		'irl_desc': "A Distributed Denial of Service (DDoS) attack is designed to force a website, computer, or online service offline. This is accomplished by flooding the target with many requests, consuming its capacity and rendering it unable to respond to legitimate requests. The malicious traffic comes from a variety of different IP addresses, often from members of a botnet. This makes the attack more difficult to defend against and enables the attackers to generate a larger volume of malicious traffic than a single system can generate on its own."
		},
	Threat.RANSOMWARE: {
		'health': 150,
		'damage': 250,
		'speed': 105,
		'special_ability': "It locks a tower and demands gold.",
		'irl_desc': "Ransomware is an advanced type of malicious software that locks out files and systems in order to take the user's data hostage. It uses sophisticated algorithms to encrypt data, making it unreadable or inaccessible without a special decryption key that is exclusively in the possession of the attackers. Additionally, access to the hostage data can be restored by paying a ransom, which is often demanded in cryptocurrency. Lastly, there is a saying, “Never Pay The Ransom”, as retrieving the hostage data is not guaranteed."
		},
	Threat.ZERO: {
		'health': 220,
		'damage': 350,
		'speed': 110,
		'special_ability': "Ignored by the defense tower at first (such as antivirus, firewall, and other defenses), a patch management system is needed.",
		'irl_desc': "A zero-day exploit is a software vulnerability that is either known yet unpatched or is completely unknown to the developers. The name comes from the concept that developers have zero days to address the vulnerability before it is actively exploited."
		},
	Threat.ILOVEYOU: {
		'health': 15000,
		'damage': 100,
		'speed': 100,
		'special_ability': "Spawns multiple viruses on other routes/lanes at specific health, while normal threats are spawned continuously ",
		'irl_desc': "In May 2000, a computer worm called ILOVEYOU quickly spread by email throughout the world. This software, also referred to as the LoveLetter worm, was based on a straightforward yet incredibly powerful social engineering technique. The subject line \"ILOVEYOU\" and the attachment \"LOVE - LETTER - FOR - YOU.txt.vbs\" appeared in users' inboxes. The file's actual nature as a Visual Basic Script was concealed by the double extension. The worm would start running as soon as the user opened the attachment, erasing files from the victim's computer and—most notably—sending a copy of itself to each contact in the user's Microsoft Outlook address book."
			},
	Threat.CONFICKER: {
		'health': 30000,
		'damage': 200,
		'speed': 100,
		'special_ability': "Periodically spawns botnet drones on the battlefield.",
		'irl_desc': "The computer worm Conficker, also referred to as Downup, Downadup, or Kido, was first discovered in November 2008, and it targets the Microsoft Windows operating system, specifically in Windows Server Service. It goes along with a number of advanced malware techniques, and it has proven super challenging to stop. It spreads by using dictionary attacks on administrator passwords and vulnerabilities in Windows OS software to create a botnet. The Conflicker takes advantage of the vulnerability in the buffer overflow of the Windows Server Service through the RPC requests, where it then allows attackers to install malware, steal data, or control the machine as part of a botnet. Moreover, it can also download arbitrary files, including malware, and deactivate important system services and security programs."
		},
	Threat.WANNACRY: {
		'health': 50000,
		'damage': 320,
		'speed': 100,
		'special_ability': "Periodically stuns defensive towers on the battlefield. ",
		'irl_desc': "Ransomware is a kind of malicious software that is used to extort money, and the WannaCry Ransomware that attacked Windows OS in May 2017 is one example. It is one of the most infamous operating system vulnerabilities, and it spreads to more than 300,000 computers across 150 countries. It encrypts important user data and demands Bitcoin as ransom. The attackers exploit a flaw in the Microsoft Windows operating system, the EternalBlue Windows vulnerability in the Server Message Block protocol. The WannaCry ransomware spreads quickly like a worm by remotely running its malware on susceptible computers, then automatically scans and infects more machines. An attacker can transmit specially crafted network packets to cause the target to execute arbitrary code."
		},
	Threat.NOTPETYA: {
		'health': 90000,
		'damage': 200,
		'speed': 100,
		'special_ability': "Displays a fake ransom message offering server health recovery in exchange for payment. If the player chooses to pay, the malware intensifies its attack, moves faster, and gives the tower an actual health so it can be destroyed. If ignored, it continues to spread and damage the system normally. ",
		'irl_desc': "NotPetya is a destructive malware variant that appeared in June 2017, initially targeting Ukraine before spreading globally. It masquerades as ransomware but was built primarily to destroy data rather than generate ransom payments. Even when victims paid, recovery was effectively impossible because NotPetya's encryption routine does not preserve the information needed for decryption."
		},
	Threat.DOOM: {
		'health': 110000,
		'damage': 200,
		'speed': 100,
		'special_ability': "Spawns swarm enemies along the paths, such as botnet drones, DDoS, spam emails, worms, and even insider threats.",
		'irl_desc': "MyDoom was actually a computer worm rather than a virus. However, it is sometimes called the MyDoom Virus, which is a highly destructive malware first discovered in January 2004. It remains the fastest-spreading mass-mailing threat in history. It infected an estimated millions of computers and caused billions in damages by turning machines into botnets, causing massive Distributed Denial-of-Service (DDoS) attacks. "
		},
	Threat.TROJAN: {
		'health': 150000,
		'damage': 150,
		'speed': 100,
		'special_ability': "Initially introduced as a guide at the start of the game. Revive dead enemies and periodically spawns types of enemies.",
		'irl_desc': "Trojan horse attacks deceive people into running programs that appear harmless but actually have malicious intent by using social engineering and deception. Trojans are programs that appear as attachments, downloads, or fraudulent files or programs that pretend to do one thing but actually do another, usually maliciously."
		},
}


@onready var desc_name: Label = $Reddatabasebg/Name
@onready var desc_damage: Label = $Reddatabasebg/Damage
@onready var desc_speed: Label = $Reddatabasebg/MSpeed
@onready var desc_health: Label = $Reddatabasebg/Health
@onready var desc_sp: Label = $Reddatabasebg/Special
@onready var desc_desc: Label = $Reddatabasebg/Special/RealLifeDesc/Description

@onready var animation: AnimatedSprite2D = $Reddatabasebg/AnimatedSprite2D
@onready var worm_animation = $Reddatabasebg/AnimatedSprite2D2

func _on_threat_20_pressed() -> void:
	desc_name.text = threat_name[19]
	desc_damage.text = str(THREAT_DATA[19]['damage'])
	desc_speed.text = str(THREAT_DATA[19]['speed'])
	desc_health.text = str(THREAT_DATA[19]['health'])
	desc_sp.text = str(THREAT_DATA[19]['special_ability'])
	desc_desc.text = str(THREAT_DATA[19]['irl_desc'])
	animation.visible = true
	worm_animation.visible = false

func _on_threat_19_pressed() -> void:
	desc_name.text = threat_name[18]
	desc_damage.text = str(THREAT_DATA[18]['damage'])
	desc_speed.text = str(THREAT_DATA[18]['speed'])
	desc_health.text = str(THREAT_DATA[18]['health'])
	desc_sp.text = str(THREAT_DATA[18]['special_ability'])
	desc_desc.text = str(THREAT_DATA[18]['irl_desc'])
	animation.visible = true
	worm_animation.visible = false

func _on_threat_18_pressed() -> void:
	desc_name.text = threat_name[17]
	desc_damage.text = str(THREAT_DATA[17]['damage'])
	desc_speed.text = str(THREAT_DATA[17]['speed'])
	desc_health.text = str(THREAT_DATA[17]['health'])
	desc_sp.text = str(THREAT_DATA[17]['special_ability'])
	desc_desc.text = str(THREAT_DATA[17]['irl_desc'])
	animation.visible = true
	worm_animation.visible = false

func _on_threat_17_pressed() -> void:
	desc_name.text = threat_name[16]
	desc_damage.text = str(THREAT_DATA[16]['damage'])
	desc_speed.text = str(THREAT_DATA[16]['speed'])
	desc_health.text = str(THREAT_DATA[16]['health'])
	desc_sp.text = str(THREAT_DATA[16]['special_ability'])
	desc_desc.text = str(THREAT_DATA[16]['irl_desc'])
	animation.play("wannacry")
	animation.visible = true
	worm_animation.visible = false

func _on_threat_16_pressed() -> void:
	desc_name.text = threat_name[15]
	desc_damage.text = str(THREAT_DATA[15]['damage'])
	desc_speed.text = str(THREAT_DATA[15]['speed'])
	desc_health.text = str(THREAT_DATA[15]['health'])
	desc_sp.text = str(THREAT_DATA[15]['special_ability'])
	desc_desc.text = str(THREAT_DATA[15]['irl_desc'])
	animation.play("conficker")
	animation.visible = true
	worm_animation.visible = false

func _on_threat_15_pressed() -> void:
	desc_name.text = threat_name[14]
	desc_damage.text = str(THREAT_DATA[14]['damage'])
	desc_speed.text = str(THREAT_DATA[14]['speed'])
	desc_health.text = str(THREAT_DATA[14]['health'])
	desc_sp.text = str(THREAT_DATA[14]['special_ability'])
	desc_desc.text = str(THREAT_DATA[14]['irl_desc'])
	animation.play("ilu")
	animation.visible = true
	worm_animation.visible = false

func _on_threat_14_pressed() -> void:
	desc_name.text = threat_name[13]
	desc_damage.text = str(THREAT_DATA[13]['damage'])
	desc_speed.text = str(THREAT_DATA[13]['speed'])
	desc_health.text = str(THREAT_DATA[13]['health'])
	desc_sp.text = str(THREAT_DATA[13]['special_ability'])
	desc_desc.text = str(THREAT_DATA[13]['irl_desc'])
	animation.play("zero")
	animation.visible = true
	worm_animation.visible = false

func _on_threat_13_pressed() -> void:
	desc_name.text = threat_name[12]
	desc_damage.text = str(THREAT_DATA[12]['damage'])
	desc_speed.text = str(THREAT_DATA[12]['speed'])
	desc_health.text = str(THREAT_DATA[12]['health'])
	desc_sp.text = str(THREAT_DATA[12]['special_ability'])
	desc_desc.text = str(THREAT_DATA[12]['irl_desc'])
	animation.play("ransomware")
	animation.visible = true
	worm_animation.visible = false

func _on_threat_12_pressed() -> void:
	desc_name.text = threat_name[11]
	desc_damage.text = str(THREAT_DATA[11]['damage'])
	desc_speed.text = str(THREAT_DATA[11]['speed'])
	desc_health.text = str(THREAT_DATA[11]['health'])
	desc_sp.text = str(THREAT_DATA[11]['special_ability'])
	desc_desc.text = str(THREAT_DATA[11]['irl_desc'])
	animation.play("ddos")
	animation.visible = true
	worm_animation.visible = false


func _on_threat_11_pressed() -> void:
	desc_name.text = threat_name[10]
	desc_damage.text = str(THREAT_DATA[10]['damage'])
	desc_speed.text = str(THREAT_DATA[10]['speed'])
	desc_health.text = str(THREAT_DATA[10]['health'])
	desc_sp.text = str(THREAT_DATA[10]['special_ability'])
	desc_desc.text = str(THREAT_DATA[10]['irl_desc'])
	animation.play("sql")
	animation.visible = true
	worm_animation.visible = false

func _on_threat_9_pressed() -> void:
	desc_name.text = threat_name[8]
	desc_damage.text = str(THREAT_DATA[8]['damage'])
	desc_speed.text = str(THREAT_DATA[8]['speed'])
	desc_health.text = str(THREAT_DATA[8]['health'])
	desc_sp.text = str(THREAT_DATA[8]['special_ability'])
	desc_desc.text = str(THREAT_DATA[8]['irl_desc'])
	animation.play("insider")
	animation.visible = true
	worm_animation.visible = false

func _on_threat_8_pressed() -> void:
	desc_name.text = threat_name[7]
	desc_damage.text = str(THREAT_DATA[7]['damage'])
	desc_speed.text = str(THREAT_DATA[7]['speed'])
	desc_health.text = str(THREAT_DATA[7]['health'])
	desc_sp.text = str(THREAT_DATA[7]['special_ability'])
	desc_desc.text = str(THREAT_DATA[7]['irl_desc'])
	animation.play("trojan")
	animation.visible = true
	worm_animation.visible = false

func _on_threat_7_pressed() -> void:
	desc_name.text = threat_name[6]
	desc_damage.text = str(THREAT_DATA[6]['damage'])
	desc_speed.text = str(THREAT_DATA[6]['speed'])
	desc_health.text = str(THREAT_DATA[6]['health'])
	desc_sp.text = str(THREAT_DATA[6]['special_ability'])
	desc_desc.text = str(THREAT_DATA[6]['irl_desc'])
	animation.play("creds")
	animation.visible = true
	worm_animation.visible = false


func _on_threat_6_pressed() -> void:
	desc_name.text = threat_name[5]
	desc_damage.text = str(THREAT_DATA[5]['damage'])
	desc_speed.text = str(THREAT_DATA[5]['speed'])
	desc_health.text = str(THREAT_DATA[5]['health'])
	desc_sp.text = str(THREAT_DATA[5]['special_ability'])
	desc_desc.text = str(THREAT_DATA[5]['irl_desc'])
	animation.play("botnet")
	animation.visible = true
	worm_animation.visible = false
	

func _on_threat_5_pressed() -> void:
	desc_name.text = threat_name[4]
	desc_damage.text = str(THREAT_DATA[4]['damage'])
	desc_speed.text = str(THREAT_DATA[4]['speed'])
	desc_health.text = str(THREAT_DATA[4]['health'])
	desc_sp.text = str(THREAT_DATA[4]['special_ability'])
	desc_desc.text = str(THREAT_DATA[4]['irl_desc'])
	animation.play("spyware")
	animation.visible = true
	worm_animation.visible = false


func _on_threat_4_pressed() -> void:
	desc_name.text = threat_name[3]
	desc_damage.text = str(THREAT_DATA[3]['damage'])
	desc_speed.text = str(THREAT_DATA[3]['speed'])
	desc_health.text = str(THREAT_DATA[3]['health'])
	desc_sp.text = str(THREAT_DATA[3]['special_ability'])
	desc_desc.text = str(THREAT_DATA[3]['irl_desc'])
	animation.visible = false
	worm_animation.visible = true

func _on_threat_3_pressed() -> void:
	desc_name.text = threat_name[2]
	desc_damage.text = str(THREAT_DATA[2]['damage'])
	desc_speed.text = str(THREAT_DATA[2]['speed'])
	desc_health.text = str(THREAT_DATA[2]['health'])
	desc_sp.text = str(THREAT_DATA[2]['special_ability'])
	desc_desc.text = str(THREAT_DATA[2]['irl_desc'])
	animation.play("adware")
	animation.visible = true
	worm_animation.visible = false

func _on_threat_2_pressed() -> void:
	desc_name.text = threat_name[1]
	desc_damage.text = str(THREAT_DATA[1]['damage'])
	desc_speed.text = str(THREAT_DATA[1]['speed'])
	desc_health.text = str(THREAT_DATA[1]['health'])
	desc_sp.text = str(THREAT_DATA[1]['special_ability'])
	desc_desc.text = str(THREAT_DATA[1]['irl_desc'])
	animation.play("virus")
	animation.visible = true
	worm_animation.visible = false

func _on_threat_1_pressed() -> void:
	desc_name.text = threat_name[0]
	desc_damage.text = str(THREAT_DATA[0]['damage'])
	desc_speed.text = str(THREAT_DATA[0]['speed'])
	desc_health.text = str(THREAT_DATA[0]['health'])
	desc_sp.text = str(THREAT_DATA[0]['special_ability'])
	desc_desc.text = str(THREAT_DATA[0]['irl_desc'])
	animation.play("spam")
	animation.visible = true
	worm_animation.visible = false


func _on_threat_10_pressed() -> void:
	desc_name.text = threat_name[9]
	desc_damage.text = str(THREAT_DATA[9]['damage'])
	desc_speed.text = str(THREAT_DATA[9]['speed'])
	desc_health.text = str(THREAT_DATA[9]['health'])
	desc_sp.text = str(THREAT_DATA[9]['special_ability'])
	desc_desc.text = str(THREAT_DATA[9]['irl_desc'])
	animation.play("rootkit")
	animation.visible = true
	worm_animation.visible = false
