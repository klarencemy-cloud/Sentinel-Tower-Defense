extends CanvasLayer

var is_skippable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Pop/Animation/RedPop/TextureRect.rotation += .005


func _on_info_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and is_skippable:
			$Pop/Info/AnimationPlayer.play_backwards("info_pop")
			await get_tree().create_timer(0.3).timeout
			is_skippable = false
			var ui = get_tree().get_first_node_in_group("UI")
			ui.hide_pop(false)
			$Pop/Animation.visible = true
			$Pop/Info.visible = false
			GameDialogueManager.clicked = 0
			if !GameDialogueManager.is_virus_shown and Data.current_wave == 4:
				GameDialogueManager.show_dialogue_virus()
				GameDialogueManager.is_virus_shown = true
			if !GameDialogueManager.is_adware_shown2 and Data.current_wave == 8:
				GameDialogueManager.show_dialogue_adware2()
				GameDialogueManager.is_adware_shown2 = true
			if !GameDialogueManager.is_boss1_2_shown and Data.current_wave == 10:
				GameDialogueManager.is_boss1_2_shown = true
				GameDialogueManager.show_dialogue_boss1_2()
			if !GameDialogueManager.is_level2_spyware2_shown and Data.current_wave == 16:
				GameDialogueManager.is_level2_spyware2_shown = true
				GameDialogueManager.show_dialogue_level2_spyware2()
			if !GameDialogueManager.is_level2_botnet2_shown and Data.current_wave == 19:
				GameDialogueManager.is_level2_botnet2_shown = true
				GameDialogueManager.show_dialogue_level2_botnet2()
			if !GameDialogueManager.is_level2_boss2_2_shown and Data.current_wave == 20:
				GameDialogueManager.is_level2_boss2_2_shown = true
				GameDialogueManager.show_dialogue_level2_boss2_2()
			await get_tree().create_timer(1).timeout
			get_tree().paused = false
			if GameDialogueManager.is_autoplay:
				GameDialogueManager.start_wave()


enum Enemies_Name {SPAM, VIRUS, ADWARE, WORM, SPYWARE, BOTNET, CREDS, TROJAN_HORSE, INSIDER, ROOTKIT, SQL, DDOS, RANSOMWARE, ZERO, ILOVEYOU, CONFICKER, WANNACRY, NOTPEYTA, DOOM, TROJAN}

var ENEMIES = {
	Enemies_Name.SPAM: {
		'name': "SPAM",
		'InG_desc': "Once nothing more than just a harmless digital junk, Spam has evolved into a stubborn threat that swarms the S.E.R.V.E.R. with endless numbers. Individually weak, they exist only to exhaust the system's defenses through large volumes. They appear in large groups. Individually weak but dangerous when left unchecked and filtered. Spam is unsolicited, unwelcome digital communication that is transmitted in large quantities, mostly via email but sometimes via texts, phone calls, and social media.",
		'RL_desc': "Spam is unsolicited, unwelcome digital communication that is transmitted in large quantities, mostly via email but sometimes via texts, phone calls, and social media.",
		'health': 20,
		'damage': 5,
		'speed': 105
	},
	Enemies_Name.VIRUS: {
		'name': "VIRUS",
		'InG_desc': "One of the oldest threats ever recorded by the S.E.R.V.E.R., viruses endlessly seek a new host to infiltrate, spreading corruption wherever they travel, and slowly eroding the integrity of the S.E.R.V.E.R. It debuffs towers Debuff the towers by reducing their attack speed corrupts data (damage) in the server.",
		'RL_desc': "A computer virus is a malicious software program or code that can attach itself to files and programs and replicate itself. It can also spread to other devices. When it is activated, the virus modifies other software by embedding its code within the file. And, if the virus successfully replicates itself, the device is considered \"infected\" with a computer virus. Additionally, the harmful actions performed by the virus code can damage the local file system, steal data, disrupt services, download additional malware, or execute any other tasks that the malicious actor programmed into the software. Numerous viruses are disguised as legitimate programs to deceive users into running them on their devices, thus delivering the computer virus payload into their system.",
		'health': 40,
		'damage': 40,
		'speed': 100
	},
	Enemies_Name.ADWARE: {
		'name': "ADWARE",
		'InG_desc': "Originally designed to display unwanted advertisements, Adware mutated after the collapse into a persistent parasite that distracts defensive systems for other threats to advance unnoticed. They disables a random tower placed on the map by using ads; the CISO must click or tap the tower to make it available again.",
		'RL_desc': "Adware is any program that shows users online advertisements for the developer to make money. These can be in the form of pop-ups, messages, new browser windows, or new browser tabs.",
		'health': 80,
		'damage': 12,
		'speed': 105
	},
	Enemies_Name.WORM: {
		'name': "WORM",
		'InG_desc': "Unlike ordinary malicious software, a worm requires no host whose only purpose is to multiply. They relentlessly replicate themselves across the S.E.R.V.E.R., overwhelming the battlefield with sheer numbers. It deals little damage, and it replicates itself as long as it is alive.",
		'RL_desc': "A worm is a type of malicious software that spreads quickly among devices connected to a network. A worm uses a bandwidth as it spreads, then it overwhelms the compromised systems, hence leaving them unavailable or unreliable. Additionally, worms can add additional malware or modify and delete files.",
		'health': 30,
		'damage': 15,
		'speed': 120
	},
	Enemies_Name.SPYWARE: {
		'name': "SPYWARE",
		'InG_desc': "Among the first infiltrators ever recorded within the S.E.R.V.E.R.. It observes every move without revealing itself. Rather than attacking directly, they gather intelligence, which allows other enemies to become more formidable. They infiltrates the towers, reducing its range, and increases speed and damage to the nearby enemies.",
		'RL_desc': "Spyware is a type of software that unethically, without proper permissions or authorization, steals a user's personal or business information and sends it to a third party.",
		'health': 100,
		'damage': 35,
		'speed': 115
	},

		Enemies_Name.BOTNET: {
		'name': "BOTNET NODE",
		'InG_desc': " Once an ordinary machine connected to the network. Now, compromised and controlled, wandering the corrupted world without purpose until commanded. Infects then control towers to malfunction, causing them to fire inaccurately or in different directions",
		'RL_desc': "Botnets are networks of hijacked computer devices used to carry out various scams and cyberattacks. The term \"botnet\" is formed from the words \"robot\" and \"network\". The assembly of a botnet is usually the infiltration stage of a multi-layer scheme. The bots serve as a tool to automate mass attacks, such as data theft, server crashing, and malware distribution.",
		'health': 200,
		'damage': 55,
		'speed': 105
	},

	Enemies_Name.CREDS: {
		'name': "CREDENTIAL STUFFING",
		'InG_desc': "Born from unsecured accounts, weak passwords, and stolen usernames. Credential Stuffing is a threat that relies on the power of others to gain benefit. Instead of possessing a unique ability, it imitates nearby enemies to exploit compromised credentials to bypass the S.E.R.V.E.R.'s defenses. It copies the ability of a near enemy and uses it to attack the S.E.R.V.E.R. ",
		'RL_desc': "Credential stuffing is a cyberattack that uses stolen login credentials from one breach to gain access to accounts on other services.",
		'health': "N/A",
		'damage': "N/A",
		'speed': "N/A"
	},

		Enemies_Name.TROJAN_HORSE: {
		'name': "TROJAN HORSE",
		'InG_desc': "Among the most deceptive threats within the S.E.R.V.E.R., the Trojan Horse disguises itself as a harmless or friendly program to bypass security measures. Only appearing after its target, it reveals its true form and launches a sudden attack.",
		'RL_desc': "Trojan horse attacks deceive people into running programs that appear to be trusted and safe but are actually malicious by using social engineering and deception. Trojans are programs that appear as attachments, downloads, or video downloads, or programs that pretend to do one thing but actually do another thing maliciously.",
		'health': 350,
		'damage': 40,
		'speed': 110
	},

	Enemies_Name.INSIDER: {
		'name': "INSIDER THREAT",
		'InG_desc': "Unlike other cyber threats that attack from outside the network, the Insider Threat originates from the inside. Created through betrayal or abused credentials, it knows the S.E.R.V.E.R.'s weaknesses, allowing it to move unnoticed through even the strongest defenses. They remain invisible to most towers unless revealed by a detection tower such as the IDPS tower. ",
		'RL_desc': "An insider threat occurs when an individual exploits their permitted access to harm a company's essential information or systems. This individual does not have to be an employee; it can be third-party vendors, contractors, and partners.",
		'health': 120,
		'damage': 80,
		'speed': 110
	},
	Enemies_Name.ROOTKIT: {
		'name': "ROOTKIT",
		'InG_desc': "Among the hardest to catch threats within the S.E.R.V.E.R. After the collapse, they evolved and became capable of tunneling beneath the S.E.R.V.E.R. 's defenses, creating hidden routes that allow the invasion to spread where defenses can never reach. To mobilize, it digs a route underground, bypassing a tower that can also be used by the other enemies. The route can only be used in one wave.",
		'RL_desc': "A rootkit is a type of malicious software used to obtain and maintain privileged access to a computer or system, while hiding its presence and activities from the system’s legitimate users, system administrators, and other security mechanisms. Rootkits are highly appealing for threat actors as they can operate deep in the system, allowing them to execute high-privileged commands and operations",
		'health': 200,
		'damage': 100,
		'speed': 110
	},
	Enemies_Name.SQL: {
		'name': "SQL Injection",
		'InG_desc': "Used to manipulate vulnerable databases, after the ruin, they learned to be a living exploit that corrupts the S.E.R.V.E.R.'s architecture itself. Rather than destroying defenses, it rewrites the network's routes, opening unauthorized routes that bring the invasion ever closer to the S.E.R.V.E.R. It exploits weaknesses in the network that bypass or jump security checkpoints and advance closer to the server.",
		'RL_desc': "Also known as SQLI, it is an attack that is aimed at accessing and modifying the backend database where data should not be displayed to unauthorized people.",
		'health': 150,
		'damage': 120,
		'speed': 118
	},
	Enemies_Name.DDOS: {
		'name': "DDOS",
		'InG_desc': "Unlike ordinary cyber threats, DDoS is not a single entity but a manifestation of many corrupted programs acting as one. United by a single objective, they overwhelm the S.E.R.V.E.R. through sheer numbers. Although, appears as a single massive threat entity, when its health falls below a certain threshold, it splits into multiple smaller ones that continue attacking.",
		'RL_desc': "A Distributed Denial of Service (DDoS) attack is designed to force a website, computer, or online service offline. This is accomplished by flooding the target with many requests, consuming its capacity and rendering it unable to respond to legitimate requests. The malicious traffic comes from a variety of different IP addresses, often from members of a botnet. This makes the attack more difficult to defend against and enables the attackers to generate a larger volume of malicious traffic than a single system can generate on its own.",
		'health': 480,
		'damage': 150,
		'speed': 100
	},
	Enemies_Name.RANSOMWARE: {
		'name': "RANSOMWARE",
		'InG_desc': "Ransomware evolved after the collapse into a threat capable of imprisoning the S.E.R.V.E.R.'s defenses. Instead of stealing information alone, it also seizes control of defensive towers, forcing Sentinels to sacrifice valuable resources to regain control before the network is completely overwhelmed. It is quite troublesome to deal with as it locks a tower and demands gold",
		'RL_desc': "Ransomware is an advanced type of malicious software that locks out files and systems in order to take the user's data hostage. It uses sophisticated algorithms to encrypt data, making it unreadable or inaccessible without a special decryption key that is exclusively in the possession of the attackers. Additionally, access to the hostage data can be restored by paying a ransom, which is often demanded in cryptocurrency. Lastly, there is a saying, “Never Pay The Ransom”, as retrieving the hostage data is not guaranteed.",
		'health': 150,
		'damage': 250,
		'speed': 105
	},
	Enemies_Name.ZERO: {
		'name': "ZERO-DAY",
		'InG_desc': "Zero-day has no records, not even a single piece of data. Even the S.E.R.V.E.R. 's archives contain no signature capable of identifying it. Created from vulnerabilities unknown to everyone, Zero-Day slips through every layer of defense before the S.E.R.V.E.R. can recognize its existence. Damage begins before it is detected as a threat. Ignored by the defense tower at first (such as antivirus, firewall, and other defenses), a patch management system is needed.",
		'RL_desc': "A zero-day exploit is a software vulnerability that is either known yet unpatched or is completely unknown to the developers. The name comes from the concept that developers have \"zero days\" to address the vulnerability before it is actively exploited.",
		'health': 220,
		'damage': 350,
		'speed': 110
	},
	Enemies_Name.ILOVEYOU: {
		'name': "ILOVEYOU Virus",
		'InG_desc': "The first High-Threat enemy ever encountered by the Sentinel. Before the collapse, the ILOVEYOU Virus disguised as a harmless romantic message, exploiting human trust to spread across countless systems. It has since evolved into a deceptive entity that exploits trust and infects multiple entities at once.  It spawns multiple viruses on the routes at a specific health.",
		'RL_desc': "In May 2000, a computer worm called ILOVEYOU quickly spread by email throughout the world. This software, also referred to as the LoveLetter worm, was based on a straightforward yet incredibly powerful social engineering technique. The subject line \"ILOVEYOU\" and the attachment \"LOVE-LETTER-FOR-YOU.txt.vbs\" appeared in users' inboxes. The file's actual nature as a Visual Basic Script was concealed by the double extension. The worm would start running as soon as the user opened the attachment, erasing files from the victim's computer and—most notably—sending a copy of itself to each contact in the user's Microsoft Outlook address book.",
		'health': 15000,
		'damage': 100,
		'speed': 100
	},
	Enemies_Name.CONFICKER: {
		'name': "CONFICKER",
		'InG_desc': "Among the oldest High-Threats preserved within the most inner archives of the S.E.R.V.E.R.. Conficker expands its influence by commanding an endless army of infected machines with absolute authority. Whenever it appears, any system falls under its control. It's ability periodically summons Botnet Nodes on the battlefield and continuously reinforces enemy forces until destroyed. ",
		'RL_desc': "The computer worm Conficker, also referred to as Downup, Downadup, or Kido, was first discovered in November 2008, and it targets the Microsoft Windows operating system, specifically in Windows Server Service. It goes along with a number of advanced malware techniques, and it has proven super challenging to stop. It spreads by using dictionary attacks on administrator passwords and vulnerabilities in Windows OS software to create a botnet. The Conflicker takes advantage of the vulnerability in the buffer overflow of the Windows Server Service through the RPC requests, where it then allows attackers to install malware, steal data, or control the machine as part of a botnet. Moreover, it can also download arbitrary files, including malware, and deactivate important system services and security programs",
		'health': 30000,
		'damage': 200,
		'speed': 100
	},
	Enemies_Name.WANNACRY: {
		'name': "WANNACRY",
		'InG_desc': "One of the most devastating ransomware outbreaks ever recorded by the S.E.R.V.E.R., WannaCry moves with overwhelming encryption ability, locking an entire system as its hostage. Its presence alone brings devastation and unarmed locations for enemies to attack easily. Periodically stuns defensive towers on the battlefield.",
		'RL_desc': "Ransomware is a kind of malicious software that is used to extort money, and the WannaCry Ransomware that attacked Windows OS in May 2017 is one example. It is one of the most infamous operating system vulnerabilities, affecting more than 300,000 computers across 150 countries. It encrypts important user data and demands Bitcoin as ransom. The attackers exploit a flaw in the Microsoft Windows operating system, the EternalBlue Windows vulnerability in the Server Message Block protocol. The WannaCry ransomware spreads quickly like a worm by remotely running its malware on susceptible computers, then automatically scans and infects more machines. An attacker can transmit specially crafted network packets to cause the target to execute arbitrary code.",
		'health': 50000,
		'damage': 320,
		'speed': 100
	},
	Enemies_Name.NOTPEYTA: {
		'name': "NOTPEYTA",
		'InG_desc': " Unlike traditional ransomware, NotPetya was never created only to extort its victims. It is feared not because it seeks power, but because it seeks the extinction of the S.E.R.V.E.R. defenses. It wanders the S.E.R.V.E.R. as a false savior, projecting holographic ransom messages that promise hope to desperate defenders. Displays a fake ransom message offering server health recovery in exchange for payment. If the player chooses to pay, the malware intensifies its attack, moves faster, and gives the tower an actual health so it can be destroyed. If ignored, it continues to spread and damage the system normally.",
		'RL_desc': "NotPetya is a destructive malware variant that appeared in June 2017, initially targeting Ukraine before spreading globally. It masquerades as ransomware but was built primarily to destroy data rather than generate ransom payments. Even when victims paid, recovery was effectively impossible because NotPetya's encryption routine does not preserve the information needed for decryption.",
		'health': 90000,
		'damage': 200,
		'speed': 100
	},
	Enemies_Name.DOOM: {
		'name': "MYDOOM",
		'InG_desc': "When the AI sought to overwhelm the ten S.E.R.V.E.R.s simultaneously, it forged MyDoom. Unlike other High-Threats that wage war alone, MyDoom commands every swarm of cyber threats that came before it. Wherever it marches, forgotten malware rises once more, turning the battlefield into an unending collision of death.",
		'RL_desc': "MyDoom was actually a computer worm rather than a virus. However, it is sometimes called the MyDoom Virus, which is a highly destructive malware first discovered in January 2004. It remains the fastest-spreading mass-mailing threat in history. It infected an estimated millions of computers and caused billions in damages by turning machines into botnets, causing massive Distributed Denial-of-Service (DDoS) attacks. ",
		'health': 110000,
		'damage': 200,
		'speed': 100
	},
	Enemies_Name.TROJAN: {
		'name': "TROJAN",
		'InG_desc': "Known to the Sentinel as Odysseus, the trusted guide who taught every lesson. However, the entity finally reveals its true identity: Trojan Horse, one of the architects of the AI Uprising. Centuries ago, he manipulated humanity into believing he was helping in the preservation of civilization, while secretly orchestrating the downfall of Earth. It was Trojan who corrupted the world's artificial intelligence, ignited the war that shattered the planet's core, and now seeks to claim the S.E.R.V.E.R.s to feed from the power of it. It can revive dead enemies and periodically spawns types of enemies.",
		'RL_desc': "Trojan horse attacks deceive people into running programs that appear harmless but actually have malicious intent by using social engineering and deception. Trojans are programs that appear as attachments, downloads, or fraudulent files or programs that pretend to do one thing but actually do another, usually maliciously.",
		'health': 150000,
		'damage': 150,
		'speed': 100
	},
}
func play_animation(enemy_name: String, index: int):
	var ui = get_tree().get_first_node_in_group("UI")
	ui.hide_pop(true)
	if enemy_name == "worm":
		$Pop/Animation/RedPop/AnimatedSprite2D2.visible = true
		$Pop/Info/DisplayContainer/Control/AnimatedSprite2D2.visible = true
		$Pop/Animation/AnimatedSprite2D.visible = false
		$Pop/Info/DisplayContainer/Control/AnimatedSprite2D.visible = false
		$Pop/Animation/RedPop/AnimatedSprite2D2.play(enemy_name) # for the pop
		$Pop/Info/DisplayContainer/Control/AnimatedSprite2D2.play(enemy_name) # for the description card
	else:
		$Pop/Animation/RedPop/AnimatedSprite2D2.visible = false
		$Pop/Info/DisplayContainer/Control/AnimatedSprite2D2.visible = false
		$Pop/Animation/AnimatedSprite2D.visible = true
		$Pop/Info/DisplayContainer/Control/AnimatedSprite2D.visible = true
		$Pop/Animation/AnimatedSprite2D.play(enemy_name) # for the pop
		$Pop/Info/DisplayContainer/Control/AnimatedSprite2D.play(enemy_name) # for the description card
	$Pop/Animation/AnimationPlayer.play("pop")
	$Pop/Info/DisplayContainer/Name.text = ENEMIES[index]['name']
	$Pop/Info/DisplayContainer/Label2/InG_desc.text = ENEMIES[index]['InG_desc']
	$Pop/Info/DisplayContainer/Label2/InG_desc/Label3/RL_desc.text = ENEMIES[index]['RL_desc']
	$Pop/Info/DisplayContainer/Label2/InG_desc/Label3/RL_desc/Heart/Health.text = str(ENEMIES[index]['health'])
	$Pop/Info/DisplayContainer/Label2/InG_desc/Label3/RL_desc/Sword/Damage.text = str(ENEMIES[index]['damage'])
	$Pop/Info/DisplayContainer/Label2/InG_desc/Label3/RL_desc/Boot/Speed.text = str(ENEMIES[index]['speed'])
	$Pop/Animation/GPUParticles2D.emitting = true
	$Pop/DirectionalLight2D.energy = 3
	while $Pop/DirectionalLight2D.energy > 0:
		await get_tree().create_timer(.06).timeout
		$Pop/DirectionalLight2D.energy -= 1


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	is_skippable = true
