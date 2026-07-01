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
		700
	)
	
	var threat_container_size = $SentinelContainer.size
	var card_container_size = $SentinelContainer/CardContainer.size
	$SentinelContainer/CardContainer.position.x = clamp(
		$SentinelContainer/CardContainer.position.x,
		0,
		0
	)
	$SentinelContainer/CardContainer.position.y = clamp(
		$SentinelContainer/CardContainer.position.y,
		-580,
		11
	)
	

var sentinel_name: Array = [
	"Ethical Hacker",
	"System Administrator",
	"Intrusion Analyst",
	"Security Architect",
	"Malware Analyst",
	"Deception Specialist",
	]

	
enum Sentinel {ETHICAL, SYSAD, INTRUSION, SECURITY, MALWARE, DECEPTION}

var SENTINEL_DATA = {
	Sentinel.ETHICAL: {
		'special_ability': "Unlocks Sandbox Mode, no combat features.",
		'cooldown': 'N/A',
		'passive_ability': "Reveal enemy statistics.",
		'irl_desc': "This is a cybersecurity expert who lawfully intrudes on a computer or network. They have the permission and approval to hack into a certain computing device. Lastly, they usually provide a security assessment to provide a comprehensive way to further improve a system."
	},
		Sentinel.SYSAD: {
		'special_ability': "Repair server health by 3%.",
		'cooldown': "1 minute and 30 seconds",
		'passive_ability': "Generates gold and EXP periodically for the player.",
		'irl_desc': "Their main role is to provide support, troubleshoot problems, and ensure that the computer infrastructure, such as servers and the network, is functioning."
	},
		Sentinel.INTRUSION: {
		'special_ability': "Deploys a shield with 1500 hit points around the Server that reflects damage to attackers.",
		'cooldown': "30 seconds",
		'passive_ability': "Reduce damage to the server by 5%.",
		'irl_desc': "An Intrusion Analyst is responsible for detecting, analyzing, and responding to cybersecurity threats or unauthorized access within an organization's computer networks. They monitor network traffic, investigate security incidents, and use specialized tools to identify potential breaches or vulnerabilities. Their work helps prevent data loss and protects sensitive information by quickly addressing and mitigating cyber threats. Additionally, they often collaborate with other IT and security teams to improve overall security posture and may assist in developing security policies and response plans."
	},
		Sentinel.SECURITY: {
		'special_ability': "Increases nearby towers' range by 20% and attack speed by 15% for 10 seconds.",
		'cooldown': "15 seconds",
		'passive_ability': "Nearby towers permanently gain an additional 5% range. ",
		'irl_desc': "Security Architects design, develop, and implement systems that prevent the infiltration of malware and other hacker-related intrusions across the IT network, thereby helping organisations to continue their activities without encouraging costly and damaging situations."
	},
		Sentinel.MALWARE: {
		'special_ability': "Examines detected threats, reveals their weaknesses, and instead of directly attacking enemies, it improves the effectiveness of other nearby defense towers' damage by 30%.",
		'cooldown': "25 seconds",
		'passive_ability': "Nearby towers gain an additional 10% damage.  ",
		'irl_desc': "A malware analyst examines malicious files and applications to comprehend how malware operates and how it can be prevented or countered. Their perspectives assist cybersecurity teams in identifying, examining, and protecting against cyber threats. They provide information on malicious software, revealing its function, what it aims for, and how actors utilize it. Additionally, they are also combating malicious software."
	},
		Sentinel.DECEPTION: {
		'special_ability': "Makes the Server invisible for 5 seconds, causing enemies near the Server to change direction.",
		'cooldown': "30 seconds",
		'passive_ability': "Slows down enemies near the server ",
		'irl_desc': "The Deception Specialist handles deception technology,  which is a strategy to attract cyber criminals away from an enterprise's true assets and divert them to a decoy or trap. The decoy mimics legitimate servers, applications, and data so that the criminal is tricked into believing that they have infiltrated and gained access to the enterprise's most important assets when in reality they have not. The strategy is employed to minimize damage and protect an organization's true assets."
	},
}

@onready var desc_name: Label = $Databasebg/Name
@onready var desc_sp: Label = $Databasebg/Special
@onready var desc_cd: Label = $Databasebg/Special/Cooldown
@onready var desc_passive: Label = $Databasebg/Special/Cooldown/Passive
@onready var desc_desc: Label = $Databasebg/Description

func _on_sentinel_6_pressed() -> void:
	print("ye")
	desc_name.text = sentinel_name[5]
	desc_sp.text = "Ability: %s"%SENTINEL_DATA[5]["special_ability"]
	desc_cd.text = "Cooldown: %s"%SENTINEL_DATA[5]["cooldown"]
	desc_passive.text = "Passive: %s"%SENTINEL_DATA[5]["passive_ability"]
	desc_desc.text = SENTINEL_DATA[5]["irl_desc"]

func _on_sentinel_5_pressed() -> void:
	desc_name.text = sentinel_name[4]
	desc_sp.text = "Ability: %s"%SENTINEL_DATA[4]["special_ability"]
	desc_cd.text = "Cooldown: %s"%SENTINEL_DATA[4]["cooldown"]
	desc_passive.text = "Passive: %s"%SENTINEL_DATA[4]["passive_ability"]
	desc_desc.text = SENTINEL_DATA[4]["irl_desc"]

func _on_sentinel_4_pressed() -> void:
	desc_name.text = sentinel_name[3]
	desc_sp.text = "Ability: %s"%SENTINEL_DATA[3]["special_ability"]
	desc_cd.text = "Cooldown: %s"%SENTINEL_DATA[3]["cooldown"]
	desc_passive.text = "Passive: %s"%SENTINEL_DATA[3]["passive_ability"]
	desc_desc.text = SENTINEL_DATA[3]["irl_desc"]


func _on_sentinel_3_pressed() -> void:
	desc_name.text = sentinel_name[2]
	desc_sp.text = "Ability: %s"%SENTINEL_DATA[2]["special_ability"]
	desc_cd.text = "Cooldown: %s"%SENTINEL_DATA[2]["cooldown"]
	desc_passive.text = "Passive: %s"%SENTINEL_DATA[2]["passive_ability"]
	desc_desc.text = SENTINEL_DATA[2]["irl_desc"]


func _on_sentinel_2_pressed() -> void:
	desc_name.text = sentinel_name[1]
	desc_sp.text = "Ability: %s"%SENTINEL_DATA[1]["special_ability"]
	desc_cd.text = "Cooldown: %s"%SENTINEL_DATA[1]["cooldown"]
	desc_passive.text = "Passive: %s"%SENTINEL_DATA[1]["passive_ability"]
	desc_desc.text = SENTINEL_DATA[1]["irl_desc"]

func _on_sentinel_1_pressed() -> void:
	desc_name.text = sentinel_name[0]
	desc_sp.text = "Ability: %s"%SENTINEL_DATA[0]["special_ability"]
	desc_cd.text = "Cooldown: %s"%SENTINEL_DATA[0]["cooldown"]
	desc_passive.text = "Passive: %s"%SENTINEL_DATA[0]["passive_ability"]
	desc_desc.text = SENTINEL_DATA[0]["irl_desc"]
