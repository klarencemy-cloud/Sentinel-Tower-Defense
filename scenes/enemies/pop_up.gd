extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Pop/Animation/RedPop/TextureRect.rotation += .005


func _on_info_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			$Pop/Animation.visible = false
			$Pop/Info/AnimationPlayer.play_backwards("info_pop")
			await get_tree().create_timer(0.3).timeout
			$Pop/Info.visible = false
			var ui = get_tree().get_first_node_in_group("UI")
			ui.hide_pop(false)
			GameDialogueManager.clicked = 0
			await get_tree().create_timer(1).timeout
			get_tree().paused = false
			GameDialogueManager.start_wave()
		
enum Enemies_Name {SPAM, VIRUS, ADWARE, WORM, SPYWARE, BOTNET, CREDS, TROJAN_HORSE, INSIDER, ROOTKIT, SQL, DDOS, RANSOMWARE, ZERO, ILOVEYOU, CONFICKER, WANNACRY, NOTPEYTA, DOOM, TROJAN}

var ENEMIES = {
	Enemies_Name.SPAM: {
		'name': "SPAM",
		'InG_desc': "They spawn in swarms or in groups, making towers less efficient as they come in groups.",
		'RL_desc': "Spam is unsolicited, unwelcome digital communication that is transmitted in large quantities, mostly via email but sometimes via texts, phone calls, and social media.",
		'health': 20,
		'damage': 5,
		'speed': 105
	},
	Enemies_Name.VIRUS: {
		'name': "VIRUS",
		'InG_desc': "It debuffs towers and corrupts data (damage) in the server.",
		'RL_desc': "A computer virus is a malicious software program or code that can attach itself to files and programs and replicate itself. It can also spread to other devices. When it is activated, the virus modifies other software by embedding its code within the file. And, if the virus successfully replicates itself, the device is considered \"infected\" with a computer virus. Additionally, the harmful actions performed by the virus code can damage the local file system, steal data, disrupt services, download additional malware, or execute any other tasks that the malicious actor programmed into the software. Numerous viruses are disguised as legitimate programs to deceive users into running them on their devices, thus delivering the computer virus payload into their system.",
		'health': 40,
		'damage': 40,
		'speed': 100
	},
	Enemies_Name.ADWARE: {
		'name': "ADWARE",
		'InG_desc': "This makes a tower unavailable; the player must click or tap the tower to make it available again.",
		'RL_desc': "Adware is any program that shows users online advertisements for the developer to make money. These can be in the form of pop-ups, messages, new browser windows, or new browser tabs.",
		'health': 80,
		'damage': 12,
		'speed': 105
	},
	Enemies_Name.WORM: {
		'name': "WORM",
		'InG_desc': "It deals little damage, and it replicates itself as long as it is alive.",
		'RL_desc': "A worm is a type of malicious software that spreads quickly among devices connected to a network. A worm uses a bandwidth as it spreads, then it overwhelms the compromised systems, hence leaving them unavailable or unreliable. Additionally, worms can add additional malware or modify and delete files.",
		'health': 30,
		'damage': 15,
		'speed': 120
	},
	Enemies_Name.SPYWARE: {
		'name': "SPYWARE",
		'InG_desc': "Infects the tower, reducing its range, and it increases enemy speed and damage to the enemies nearby.",
		'RL_desc': "Spyware is a type of software that unethically, without proper permissions or authorization, steals a user's personal or business information and sends it to a third party.",
		'health': 100,
		'damage': 35,
		'speed': 115
	},

		Enemies_Name.BOTNET: {
		'name': "BOTNET NODE",
		'InG_desc': "Infects then control towers to malfunction, causing them to fire inaccurately or in different directions",
		'RL_desc': "Botnets are networks of hijacked computer devices used to carry out various scams and cyberattacks. The term \"botnet\" is formed from the words \"robot\" and \"network\". The assembly of a botnet is usually the infiltration stage of a multi-layer scheme. The bots serve as a tool to automate mass attacks, such as data theft, server crashing, and malware distribution.",
		'health': 200,
		'damage': 55,
		'speed': 105
	},

	Enemies_Name.CREDS: {
		'name': "CREDENTIAL STUFFING",
		'InG_desc': "",
		'RL_desc': "Credential stuffing is a cyberattack that uses stolen login credentials from one breach to gain access to accounts on other services.",
		'health': "N/A",
		'damage': "N/A",
		'speed': "N/A"
	},

		Enemies_Name.TROJAN_HORSE: {
		'name': "TROJAN HORSE",
		'InG_desc': "",
		'RL_desc': "Trojan horse attacks deceive people into running programs that appear to be trusted and safe but are actually malicious by using social engineering and deception. Trojans are programs that appear as attachments, downloads, or video downloads, or programs that pretend to do one thing but actually do another thing maliciously.",
		'health': 350,
		'damage': 40,
		'speed': 110
	},

	Enemies_Name.INSIDER: {
		'name': "INSIDER THREAT",
		'InG_desc': "",
		'RL_desc': "An insider threat occurs when an individual exploits their permitted access to harm a company's essential information or systems. This individual does not have to be an employee; it can be third-party vendors, contractors, and partners.",
		'health': 120,
		'damage': 80,
		'speed': 110
	},
	Enemies_Name.ROOTKIT: {
		'name': "ROOTKIT",
		'InG_desc': "",
		'RL_desc': "A rootkit is a type of malicious software used to obtain and maintain privileged access to a computer or system, while hiding its presence and activities from the system’s legitimate users, system administrators, and other security mechanisms. Rootkits are highly appealing for threat actors as they can operate deep in the system, allowing them to execute high-privileged commands and operations",
		'health': 200,
		'damage': 100,
		'speed': 110
	},
	Enemies_Name.SQL: {
		'name': "SQL Injection",
		'InG_desc': "",
		'RL_desc': "Also known as SQLI, it is an attack that is aimed at accessing and modifying the backend database where data should not be displayed to unauthorized people.",
		'health': 150,
		'damage': 120,
		'speed': 118
	},
	Enemies_Name.DDOS: {
		'name': "DDOS",
		'InG_desc': "",
		'RL_desc': "A Distributed Denial of Service (DDoS) attack is designed to force a website, computer, or online service offline. This is accomplished by flooding the target with many requests, consuming its capacity and rendering it unable to respond to legitimate requests. The malicious traffic comes from a variety of different IP addresses, often from members of a botnet. This makes the attack more difficult to defend against and enables the attackers to generate a larger volume of malicious traffic than a single system can generate on its own.",
		'health': 480,
		'damage': 150,
		'speed': 100
	},
	Enemies_Name.RANSOMWARE: {
		'name': "RANSOMWARE",
		'InG_desc': "",
		'RL_desc': "Ransomware is an advanced type of malicious software that locks out files and systems in order to take the user's data hostage. It uses sophisticated algorithms to encrypt data, making it unreadable or inaccessible without a special decryption key that is exclusively in the possession of the attackers. Additionally, access to the hostage data can be restored by paying a ransom, which is often demanded in cryptocurrency. Lastly, there is a saying, “Never Pay The Ransom”, as retrieving the hostage data is not guaranteed.",
		'health': 150,
		'damage': 250,
		'speed': 105
	},
	Enemies_Name.ZERO: {
		'name': "ZERO-DAY",
		'InG_desc': "",
		'RL_desc': "A zero-day exploit is a software vulnerability that is either known yet unpatched or is completely unknown to the developers. The name comes from the concept that developers have \"zero days\" to address the vulnerability before it is actively exploited.",
		'health': 220,
		'damage': 350,
		'speed': 110
	},
	Enemies_Name.ILOVEYOU: {
		'name': "ILOVEYOU Virus",
		'InG_desc': "",
		'RL_desc': "In May 2000, a computer worm called ILOVEYOU quickly spread by email throughout the world. This software, also referred to as the LoveLetter worm, was based on a straightforward yet incredibly powerful social engineering technique. The subject line \"ILOVEYOU\" and the attachment \"LOVE-LETTER-FOR-YOU.txt.vbs\" appeared in users' inboxes. The file's actual nature as a Visual Basic Script was concealed by the double extension. The worm would start running as soon as the user opened the attachment, erasing files from the victim's computer and—most notably—sending a copy of itself to each contact in the user's Microsoft Outlook address book.",
		'health': 15000,
		'damage': 100,
		'speed': 100
	},
	Enemies_Name.CONFICKER: {
		'name': "CONFICKER",
		'InG_desc': "",
		'RL_desc': "The computer worm Conficker, also referred to as Downup, Downadup, or Kido, was first discovered in November 2008, and it targets the Microsoft Windows operating system, specifically in Windows Server Service. It goes along with a number of advanced malware techniques, and it has proven super challenging to stop. It spreads by using dictionary attacks on administrator passwords and vulnerabilities in Windows OS software to create a botnet. The Conflicker takes advantage of the vulnerability in the buffer overflow of the Windows Server Service through the RPC requests, where it then allows attackers to install malware, steal data, or control the machine as part of a botnet. Moreover, it can also download arbitrary files, including malware, and deactivate important system services and security programs",
		'health': 30000,
		'damage': 200,
		'speed': 100
	},
	Enemies_Name.WANNACRY: {
		'name': "WANNACRY",
		'InG_desc': "",
		'RL_desc': "Ransomware is a kind of malicious software that is used to extort money, and the WannaCry Ransomware that attacked Windows OS in May 2017 is one example. It is one of the most infamous operating system vulnerabilities, affecting more than 300,000 computers across 150 countries. It encrypts important user data and demands Bitcoin as ransom. The attackers exploit a flaw in the Microsoft Windows operating system, the EternalBlue Windows vulnerability in the Server Message Block protocol. The WannaCry ransomware spreads quickly like a worm by remotely running its malware on susceptible computers, then automatically scans and infects more machines. An attacker can transmit specially crafted network packets to cause the target to execute arbitrary code.",
		'health': 50000,
		'damage': 320,
		'speed': 100
	},
	Enemies_Name.NOTPEYTA: {
		'name': "NOTPEYTA",
		'InG_desc': "",
		'RL_desc': "NotPetya is a destructive malware variant that appeared in June 2017, initially targeting Ukraine before spreading globally. It masquerades as ransomware but was built primarily to destroy data rather than generate ransom payments. Even when victims paid, recovery was effectively impossible because NotPetya's encryption routine does not preserve the information needed for decryption.",
		'health': 90000,
		'damage': 200,
		'speed': 100
	},
	Enemies_Name.DOOM: {
		'name': "MYDOOM",
		'InG_desc': "",
		'RL_desc': "MyDoom was actually a computer worm rather than a virus. However, it is sometimes called the MyDoom Virus, which is a highly destructive malware first discovered in January 2004. It remains the fastest-spreading mass-mailing threat in history. It infected an estimated millions of computers and caused billions in damages by turning machines into botnets, causing massive Distributed Denial-of-Service (DDoS) attacks. ",
		'health': 110000,
		'damage': 200,
		'speed': 100
	},
	Enemies_Name.TROJAN: {
		'name': "TROJAN",
		'InG_desc': "",
		'RL_desc': "Trojan horse attacks deceive people into running programs that appear harmless but actually have malicious intent by using social engineering and deception. Trojans are programs that appear as attachments, downloads, or fraudulent files or programs that pretend to do one thing but actually do another, usually maliciously.",
		'health': 150000,
		'damage': 150,
		'speed': 100
	},
}
func play_animation(enemy_name: String, index: int):
	var ui = get_tree().get_first_node_in_group("UI")
	ui.hide_pop(true)
	$Pop/Animation/AnimatedSprite2D.play(enemy_name) # for the pop
	$Pop/Info/DisplayContainer/Control/AnimatedSprite2D.play(enemy_name) # for the description card
	$Pop/Animation/AnimationPlayer.play("pop")
	$Pop/Info/DisplayContainer/Name.text = ENEMIES[index]['name']
	$Pop/Info/DisplayContainer/Label2/InG_desc.text = ENEMIES[index]['InG_desc']
	$Pop/Info/DisplayContainer/Label2/InG_desc/Label3/RL_desc.text = ENEMIES[index]['RL_desc']
	$Pop/Info/DisplayContainer/Heart/Health.text = str(ENEMIES[index]['health'])
	$Pop/Info/DisplayContainer/Sword/Damage.text = str(ENEMIES[index]['damage'])
	$Pop/Info/DisplayContainer/Boot/Speed.text = str(ENEMIES[index]['speed'])
	$Pop/Animation/GPUParticles2D.emitting = true
	$Pop/DirectionalLight2D.energy = 3
	while $Pop/DirectionalLight2D.energy > 0:
		await get_tree().create_timer(.06).timeout
		$Pop/DirectionalLight2D.energy -= 1
