extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@export var next_scene_path1: String = "res://scenes/levels/level.tscn"
@export var next_scene_path2: String = "res://scenes/sandbox/sand_box.tscn"
var next_scene_path: String
var progress: Array[float] = []


var tips: Array[String] = [
	"One of the main reasons accounts get compromised is because of weak passwords. Despite this, “123456” remains one of the most commonly used passwords. Security experts recommend the use of long passwords, combinations of letters, numbers, and special symbols, and, importantly, Multi-Factor Authentication (MFA) to improve account security.",
	"Around 95 percent of the cybersecurity breaches are caused by human error. Simple mistakes such as clicking links, using weak passwords, or falling for phishing attacks allow attackers to access sensitive information.",
	"Phishing attacks remain one of the most common forms of cybercrime. Attackers use deception to act as trusted organizations and trick people into revealing confidential information, such as passwords and financial data.",
	"The 3-2-1 back-up rule. Cybersecurity experts recommend keeping three copies of files, storing them on two different storage media, and keeping one copy in a separate location. This approach helps ensure data can still be recovered after hardware failures or ransomware attacks. ",
	"Cyber Insight: A firewall acts like a digital security guard; it provides a protective barrier between a trusted internal network and untrusted external networks like the internet. Firewall checks incoming and outgoing data, only allowing safe information to pass through.",
	"Ethical hackers, also known as white-hat hackers, are experts who legally exploit a system or network to test an organization's overall security. Thus, allowing fixes on the exposed vulnerabilities before real criminals compromise them.",
	"Did you know? Malware stands for “malicious software.” It comes in many forms, and it includes viruses, worms, ransomware, and more. Each type behaves differently but has one purpose: to disrupt systems, steal information, and gain unauthorized access.",
	"Quick Fact: One of the simplest yet most powerful actions individuals and organisations can take is keeping software up to date. Security updates often include security patches that fix vulnerabilities discovered by researchers or developers. Thus, delaying updates may leave systems exposed and vulnerable to attacks that already have known solutions. ",
	"Tip: Do not rely on a single defense to protect the SERVER. Individuals and organizations use multiple layers of security as no single solution can stop every threat. Combining different defenses creates stronger protection.",
	"No single system's security is perfect. Cybersecurity is about making attacks more difficult, reducing loss and damage, and recovering quickly when attacks occur.",
	"Tip: Upgrade your tower defenses regularly. Outdated towers become less effective over time. Software updates patch vulnerabilities in the real world; thus, upgrading your towers helps to keep pace with the evolving threats.",
	"Tip: Deploy appropriate tower defense against a specific enemy. In cybersecurity, a specific enemy requires specific countermeasures, as no single solution can stop every type of threat."
]


func _ready() -> void:
	if Data.current_wave <= 10:
		$Animation/AnimatedSprite2D.play("boss1")
	elif Data.current_wave <= 20 and Data.current_wave > 10:
		$Animation/AnimatedSprite2D.play("boss2")
	elif Data.current_wave <= 30 and Data.current_wave > 20:
		$Animation/AnimatedSprite2D.play("boss3")
	elif Data.current_wave <= 40 and Data.current_wave > 30:
		$Animation/AnimatedSprite2D.play("boss4")
	elif Data.current_wave <= 50 and Data.current_wave > 40:
		$Animation/AnimatedSprite2D.play("boss5")
	else:
		$Animation/AnimatedSprite2D.play("boss6")
	randomize()
	var index: int = randi_range(0, 11)
	$Facts/Details.text = tips[index]
	if Data.is_sandbox:
		next_scene_path = next_scene_path2
	else:
		next_scene_path = next_scene_path1

	ResourceLoader.load_threaded_request(next_scene_path)


func _process(delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)

	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var pct = progress[0] * 100.0
			progress_bar.value = pct
		ResourceLoader.THREAD_LOAD_LOADED:
			var scene = ResourceLoader.load_threaded_get(next_scene_path)
			get_tree().change_scene_to_packed(scene)
			if !Data.is_sandbox and Data.current_wave == 1 and !GameDialogueManager.is_introduction_shown:
				GameDialogueManager.show_dialogue_introduction()
			if !Data.is_sandbox and Data.current_wave == 11 and !GameDialogueManager.is_level2_start_shown:
				GameDialogueManager.show_dialogue_level2_start()
			if !Data.is_sandbox and Data.current_wave == 21 and !GameDialogueManager.is_level3_start_shown:
				GameDialogueManager.show_dialogue_level3_start()
			if !Data.is_sandbox and Data.current_wave == 31 and !GameDialogueManager.is_level4_start_shown:
				GameDialogueManager.show_dialogue_level4_start()
			if !Data.is_sandbox and Data.current_wave == 41 and !GameDialogueManager.is_level5_start_shown:
				GameDialogueManager.show_dialogue_level5_start()