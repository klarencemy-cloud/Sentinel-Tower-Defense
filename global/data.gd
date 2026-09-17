extends Node

signal active_adware_changed
signal active_ransomware_changed
var default_health: float = 100.0
var max_health: float = default_health
var default_money: int = 90
var default_system_load: int = 200
const default_server_points: int = 0
var is_sandbox: bool = false
var is_vmmode: bool = false
var is_unli_money: bool = false
var is_unli_health: bool = false
var is_unli_senti_cap: bool = false
var is_maxed_lvl: bool = false
signal server_load_changed
signal ads_visible_changed

signal open_server_cyber
signal server_upgrade_purchased()

var DEVMODE = true
var is_server_cyber_shown: bool = false
signal toggle_server_scene # to toggle server upgrade visibility
signal change_challenge() # for vm


signal deactivate(selected_sentinel: Sentinel) # for sentinel

# "before" variables to store the original values before entering sandbox mode
var before_total_money: int
var before_total_health: float
var before_max_health: float
var before_max_server_load: int
var before_current_server_load: int
var before_owned_towers: Dictionary
var before_free_towers: Dictionary
var before_server_points: int
var before_player_level: int
var before_total_experience: int

# Backup for tower upgrade data to keep sandbox and non-sandbox separate
var before_tower_upgrades: Dictionary = {} # Stores backup of all tower upgrade levels and modified stats
var base_tower_stats: Dictionary = {} # Stores original base stats for all towers (set once at startup)
var vmmode_map_number: int = 1
var vmmode_resume_progress: Dictionary = {}
var vmmode_sentinels_disabled: bool = false

var VM_MAP_DATA := {
	1: {
		'title': "Ticking Bomb",
		'scene': "res://scenes/virtualmachinemode/maps/vm_map_1.tscn",
		'terrain_level_index': 0,
		'difficulty': "Easy",
		'recommended_wave': 5,
		'unlock_wave': 5,
		'unlocked': false,
		'desc': "The S.E.R.V.E.R. malfunctions; it loses health every 5 seconds. Defeat 200 virus enemies before the S.E.R.V.E.R. health reaches 0.",
	},
	2: {
		'title': "Swarm Overload",
		'scene': "res://scenes/virtualmachinemode/maps/vm_map_2.tscn",
		'terrain_level_index': 0,
		'difficulty': "Moderate",
		'recommended_wave': 10,
		'unlock_wave': 10,
		'unlocked': false,
		'desc': "A massive outbreak of Worms and Spam floods the path. Defeat 1,000 enemies without taking any damage.",
	},
	3: {
		'title': "Malware Interruption",
		'scene': "res://scenes/virtualmachinemode/maps/vm_map_3.tscn",
		'terrain_level_index': 1,
		'difficulty': "Hard",
		'recommended_wave': 16,
		'unlock_wave': 16,
		'unlocked': false,
		'desc': "The S.E.R.V.E.R. has only 1 HP left. Survive 7 waves of malware without taking any damage. A single hit costs everything.",
	},
	4: {
		'title': "Mirai Botnet",
		'scene': "res://scenes/virtualmachinemode/maps/vm_map_4.tscn",
		'terrain_level_index': 2,
		'difficulty': "Hard",
		'recommended_wave': 25,
		'unlock_wave': 25,
		'unlocked': false,
		'desc': "Inspired by a real-world exploit, a large number of Botnet drone that mainly compromise low-power devices swarms fast to attack the S.E.R.V.E.R., but are fragile as individuals. Win 7 waves to win the challenge.",
	},
	5: {
		'title': "Packet Loss",
		'scene': "res://scenes/virtualmachinemode/maps/vm_map_5.tscn",
		'terrain_level_index': 3,
		'difficulty': "Hard",
		'recommended_wave': 30,
		'unlock_wave': 30,
		'unlocked': false,
		'desc': "The map has blind spots (fog), whenever enemies are in that location, they cannot be targeted. Win 7 waves to win the challenge.",
	},
	6: {
		'title': "DDoS Stress Test",
		'scene': "res://scenes/virtualmachinemode/maps/vm_map_6.tscn",
		'terrain_level_index': 3,
		'difficulty': "Hard",
		'recommended_wave': 35,
		'unlock_wave': 35,
		'unlocked': false,
		'desc': "Only Distributed Denial-of-Service (DDoS) attacks the S.E.R.V.E.R. to test how it handles floods of internet traffic. The player must defeat 300 enemies before the timer runs out.",
	},
	7: {
		'title': "Random Defense",
		'scene': "res://scenes/virtualmachinemode/maps/vm_map_7.tscn",
		'terrain_level_index': 4,
		'difficulty': "Extreme",
		'recommended_wave': 40,
		'unlock_wave': 40,
		'unlocked': false,
		'desc': "Random towers randomly appear. The player must place them correctly and strategically. Win 7 waves to win the challenge.",
	},
	8: {
		'title': "Automatic Defense",
		'scene': "res://scenes/virtualmachinemode/maps/vm_map_8.tscn",
		'terrain_level_index': 4,
		'difficulty': "Extreme",
		'recommended_wave': 45,
		'unlock_wave': 45,
		'unlocked': false,
		'desc': "All sentinels are disabled during the challenge. Win 7 waves to win the challenge.",
		'disable_sentinels': true,
	},
	9: {
		'title': "Endless Onslaught",
		'scene': "res://scenes/virtualmachinemode/maps/vm_map_9.tscn",
		'terrain_level_index': 5,
		'difficulty': "Survival",
		'recommended_wave': 51,
		'unlock_wave': 51,
		'unlocked': false,
		'desc': "This challenge is endless. A survival game where the player must defend the S.E.R.V.E.R. with an endless number of waves.",
	},
}


var bullet_angle: Vector2

var wave_started: bool = false


var before_level_index: int
var before_current_wave: int
var current_level_index: int = 0 # map count 0 = level 1
var checkpoint_wave: int = 0 # checkpoint count
var current_wave: int = 1 # wave count

var incremental_enemy_health_bonus: float = current_wave * .02
var incremental_enemy_movespeed_bonus: float = current_wave * .01
var incremental_enemy_damage_bonus: float = current_wave * .01

var backup_server_placed := false
var backup_server_invincible := false

var is_play_shown: bool = false # to check if play button is visible

var sentinel_ethical_deployed: bool = false
var sentinel_sysad_deployed: bool = false
var sentinel_intrusion_deployed: bool = false
 # for the intrusion analyst shield
signal deploy_shield()
signal destroy_shield()
var sentinel_security_deployed: bool = false
var sentinel_malware_deployed: bool = false
var sentinel_deception_deployed: bool = false
 # for the deception debuff
signal deploy_deception(state: bool)

var damage_reduction: float = 0


var is_tower_placeable: bool = true
var is_sentinel_placeable: bool = true
var is_placing_tower: bool = false

signal cancel_tower_placement()
signal cancel_sentinel_placement()


var saved_tower_placements: Array = []
var saved_sentinel_placements: Array = []
var saved_ability_placements: Array = []

var owned_towers: Dictionary = {}
var free_towers: Dictionary = {}

signal vm_belt_changed()
signal vm_belt_selection_changed()
var vm_belt: Array = []
var vm_belt_next_id: int = 1
var vm_belt_selected_id: int = -1:
	set(value):
		vm_belt_selected_id = value
		vm_belt_selection_changed.emit()

func consume_vm_belt_item(item_id: int) -> void:
	for i in range(vm_belt.size()):
		if vm_belt[i]["id"] == item_id:
			vm_belt.remove_at(i)
			break
	vm_belt_selected_id = -1
	vm_belt_changed.emit()


func vm_belt_selected_kind() -> String:
	for item in vm_belt:
		if item["id"] == vm_belt_selected_id:
			return item["kind"]
	return ""
enum Tower {SPAM_FILTER, ANTIVIRUS, AD_BLOCKER, DATA_LOSS_PREVENTION, IDPS, QUARANTINE_CANNON, ACCESS_CONTROL_SYSTEM, AI_SECURITY, BACKUP_SERVER, ENDPOINT_PROTECTION, SANDBOX_ANALYZER, PATCH}
enum Bullet {SINGLE, FIRE, MORTAR_EXPLOSION, LASER}
enum Sentinel {ETHICAL, SYSAD, INTRUSION, SECURITY, MALWARE, DECEPTION}
enum Enemy {DEFAULT, VIRUS, ADWARE, WORM, SPYWARE, TROJAN, BOTNET, CREDS, INSIDERTHREAT, ROOTKIT, SQL, DDOS, RANSOMWARE, ZERO, BOSS1, BOSS2, BOSS3, BOSS4, BOSS5, BOSS6}
enum Ability {FIREWALL}
var TOWER_DATA = {
	Tower.SPAM_FILTER: {
		'name': 'Spam Filter',
		'isUnlocked': true,
		'cost': 45,
		'server_load': 15,
		'damage': 10,
		'reload_time': 1,
		'range': 1000,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.SINGLE,
		'thumbnail': "res://graphics/ui/tower thumbnails 2/SPAM_FILTER.png",
		'scene': "res://scenes/towers/tower_spamfilter.tscn",
		'passive': "Ricochet",
		'passive description': "Bullet bounces to the nearby enemy that deals 50% of the original damage.",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 1,
		'upgrade1cost': [10, 15, 20],
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.2,
		'upgrade2cost': [10, 15, 20],
		'tier1ability': "+1 Bounce",
		'tier1abilitydesc': "Bullets bounce an additional time.",
		'tier1abilityunlocked': false,
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade3amount': 1,
		'upgrade3cost': [10, 15, 20],
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade4amount': 15,
		'upgrade4cost': [10, 15, 20],
		'tier2ability': "Bounce Damage+",
		'tier2abilitydesc': "Ricocheted bullets' damage increased from 50% to 75%.",
		'tier2abilityunlocked': false,
		'upgrade5': "Crit Damage",
		'upgrade5level': 0,
		'upgrade5amount': 25,
		'upgrade5cost': [10, 15, 25],
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'upgrade6cost': [10, 15, 25],
		'tier3ability': "Infinite Recursion",
		'tier3abilitydesc': "Bullets has 50% chance to ricochet on kill.",
		'tier3abilityunlocked': false, },
	Tower.QUARANTINE_CANNON: {
		'name': 'Quarantine Cannon',
		'isUnlocked': false,
		'waveUnlocked': 19,
		'unlockable': false,
		'cost': 60,
		'server_load': 30,
		'damage': 100,
		'reload_time': 3,
		'range': 1000,
		'crit rate': 0,
		'crit damage': 50,
		'explosion_radius': 100,
		'bullet': Bullet.MORTAR_EXPLOSION,
		'thumbnail': "res://graphics/ui/tower thumbnails 2/QUARANTINE.png",
		'scene': "res://scenes/towers/tower_quarantinecannon.tscn",
		'passive': "Freeze",
		'passive description': "Freeze enemies on hit for 1s.",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 15,
		'upgrade1cost': [35, 55, 70],
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.2,
		'upgrade2cost': [35, 55, 70],
		'tier1ability': "Freeze+",
		'tier1abilitydesc': "Increase Frozen duration to 1.5s.",
		'tier1abilityunlocked': false,
		'upgrade3': "Crit Rate",
		'upgrade3level': 0,
		'upgrade3amount': 15,
		'upgrade3cost': [90, 115, 140],
		'upgrade4': "Range",
		'upgrade4level': 0,
		'upgrade4amount': 30,
		'upgrade4cost': [90, 115, 140],
		'tier2ability': "Thermal Lag",
		'tier2abilitydesc': "Enemies are slowed for 2s after being unfrozen.",
		'tier2abilityunlocked': false,
		'upgrade5': "Damage",
		'upgrade5level': 0,
		'upgrade5amount': 35,
		'upgrade5cost': [115, 160, 195],
		'upgrade6': "Explosion Radius",
		'upgrade6level': 0,
		'upgrade6amount': 20,
		'upgrade6cost': [115, 160, 195],
		'tier3ability': "Frozen Vulnerability",
		'tier3abilitydesc': "Frozen enemies take 15% more damage when frozen.",
		'tier3abilityunlocked': false, },
	Tower.IDPS: {
		'name': 'IDPS',
		'isUnlocked': false,
		'waveUnlocked': 16,
		'unlockable': false,
		'cost': 30,
		'damage': 0,
		'reload_time': 2.5,
		'server_load': 25,
		'range': 250,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.FIRE,
		'thumbnail': "res://graphics/ui/tower thumbnails 2/IDPS.png",
		'scene': "res://scenes/towers/tower_idps.tscn",
		'passive': "Scan Pulse",
		'passive description': "Reveals invisible enemies.",
		'tier2ability': "Slow Pulse",
		'tier2abilitydesc': "Slows enemies in its radius.",
		'tier3ability': "Vulnerability Pulse",
		'tier3abilitydesc': "Enemies in its radius takes 15% increased damage.",
		'upgrade1': "Attack Speed",
		'upgrade1level': 0,
		'upgrade1amount': 0.2,
		'upgrade1cost': [30, 45, 60],
		'upgrade2': "Range",
		'upgrade2level': 0,
		'upgrade2amount': 25,
		'upgrade2cost': [30, 45, 60],
		'upgrade3': "Attack Speed",
		'upgrade3level': 0,
		'upgrade3amount': 0.2,
		'upgrade3cost': [75, 100, 120],
		'upgrade4': "Attack Speed",
		'upgrade4level': 0,
		'upgrade4amount': 0.2,
		'upgrade4cost': [75, 100, 120],
		'upgrade5': "Attack Speed",
		'upgrade5level': 0,
		'upgrade5amount': 0.2,
		'upgrade5cost': [100, 135, 165],
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'upgrade6cost': [120, 150, 180],
		'tier1abilityunlocked': false,
		'tier2abilityunlocked': false,
		'tier3abilityunlocked': false, },
	Tower.BACKUP_SERVER: {
		'name': "Backup Server",
		'isUnlocked': false,
		'cost': 0,
		'damage': 5000,
		'server_load': 0,
		'thumbnail': "res://graphics/ui/tower thumbnails 2/BACKUP.png",
		'scene': "res://scenes/towers/tower_backup_server.tscn",
		'bullet': Bullet.FIRE,
		'upgradeable': false,
		},
	Tower.AD_BLOCKER: {
		'name': 'Ad Blocker',
		'isUnlocked': false,
		'waveUnlocked': 8,
		'unlockable': false,
		'cost': 75,
		'server_load': 20,
		'damage': 25,
		'reload_time': 2,
		'range': 250,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.FIRE,
		'thumbnail': "res://graphics/ui/tower thumbnails 2/ADBLOCKER.png",
		'scene': "res://scenes/towers/tower_ad_blocker.tscn",
		'passive': "Ad Purge",
		'passive description': "Automatically disables ads on nearby affected towers every 3s.",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 2,
		'upgrade1cost': [15, 25, 30],
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.1,
		'upgrade2cost': [15, 25, 30],
		'tier1ability': "Rapid Purge",
		'tier1abilitydesc': "Passive ability reduced to 2s.",
		'tier1abilityunlocked': false,
		'upgrade3': "Attack Speed",
		'upgrade3level': 0,
		'upgrade3amount': [0.25, 0.25, 0.2],
		'upgrade3cost': [40, 50, 60],
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade4amount': 15,
		'upgrade4cost': [40, 50, 60],
		'tier2ability': "Premium Subscription",
		'tier2abilitydesc': "Grants immunity to ads.",
		'tier2abilityunlocked': false,
		'upgrade5': "Damage",
		'upgrade5level': 0,
		'upgrade5amount': [4, 5, 5],
		'upgrade5cost': [50, 70, 85],
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'upgrade6cost': [50, 70, 90],
		'tier3ability': "Rapid Purge+",
		'tier3abilitydesc': "Passive ability reduced to 1s.",
		'tier3abilityunlocked': false,
		},
	Tower.ANTIVIRUS: {
		'name': 'Antivirus',
		'isUnlocked': false,
		'waveUnlocked': 4,
		'unlockable': false,
		'cost': 50,
		'server_load': 20,
		'damage': 30,
		'reload_time': 1,
		'range': 1000,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.SINGLE,
		'thumbnail': "res://graphics/ui/tower thumbnails 2/ANTIVIRUS.png",
		'scene': "res://scenes/towers/tower_antivirus.tscn",
		'passive': "Increased Damage to Malwares by 20%",
		'passive description': "Deals increased damage to malware enemies such as Viruses, Worms, and Trojan horses.",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 2,
		'upgrade1cost': [10, 15, 20],
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.1,
		'upgrade2cost': [10, 15, 20],
		'tier1ability': "Increased Damage+",
		'tier1abilitydesc': "Increase total increase damage to 30%.",
		'tier1abilityunlocked': false,
		'upgrade3': "Attack Speed",
		'upgrade3level': 0,
		'upgrade3amount': [0.1, 0.1, 0.1],
		'upgrade3cost': [25, 35, 40],
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade4amount': 15,
		'upgrade4cost': [25, 35, 40],
		'tier2ability': "Increased Damage++",
		'tier2abilitydesc': "Increase total increase damage to 40%.",
		'tier2abilityunlocked': false,
		'upgrade5': "Damage",
		'upgrade5level': 0,
		'upgrade5amount': [4, 5, 5],
		'upgrade5cost': [35, 45, 55],
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'upgrade6cost': [40, 50, 60],
		'tier3ability': "Increased Damage+++",
		'tier3abilitydesc': "Increase total increase damage to 50%.",
		'tier3abilityunlocked': false,
		},
		Tower.ACCESS_CONTROL_SYSTEM: {
		'name': 'Access Control System',
		'isUnlocked': false,
		'waveUnlocked': 22,
		'unlockable': false,
		'cost': 225,
		'server_load': 35,
		'damage': 120,
		'reload_time': 1.3,
		'range': 350,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.FIRE,
		'thumbnail': "res://graphics/ui/tower thumbnails 2/ACS.png",
		'scene': "res://scenes/towers/tower_acs.tscn",
		'passive': "Zero Trust Architecture",
		'passive description': "Slows enemies by 20% within its range and deals 25% bonus damage to Insider Threats.",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': [5, 5, 15],
		'upgrade1cost': [45, 70, 90],
		'upgrade2': "Range",
		'upgrade2level': 0,
		'upgrade2amount': 25,
		'upgrade2cost': [45, 70, 90],
		'tier1ability': "Identity Verification",
		'tier1abilitydesc': "Increases the slow effect to 35%.",
		'tier1abilityunlocked': false,
		'upgrade3': "Crit Rate",
		'upgrade3level': 0,
		'upgrade3amount': 15,
		'upgrade3cost': [115, 145, 180],
		'upgrade4': "Attack Speed",
		'upgrade4level': 0,
		'upgrade4amount': 0.2,
		'upgrade4cost': [115, 145, 180],
		'tier2ability': "Enhanced Restrictions",
		'tier2abilitydesc': "Increase damage against Insider Threats by an additional of 25% and enhances the slow by an additional 10%",
		'tier2abilityunlocked': false,
		'upgrade5': "Damage",
		'upgrade5level': 0,
		'upgrade5amount': [30, 30, 35],
		'upgrade5cost': [145, 200, 250],
		'upgrade6': "Crit Damage",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'upgrade6cost': [180, 225, 270],
		'tier3ability': "Psuedo Lockdown",
		'tier3abilitydesc': "Enemies entering the tower range for the first time are immediately slowed by 60% for 3 seconds, then return to the normal slow effect.",
		'tier3abilityunlocked': false,
		},
		Tower.ENDPOINT_PROTECTION: {
		'name': 'Endpoint Protection',
		'isUnlocked': false,
		'waveUnlocked': 32,
		'unlockable': false,
		'cost': 350,
		'server_load': 45,
		'damage': 180,
		'reload_time': 1.25,
		'range': 350,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.FIRE,
		'thumbnail': "res://graphics/ui/tower thumbnails 2/ENDPOINT_PROTECTION.png",
		'scene': "res://scenes/towers/tower_endpoint_protection.tscn",
		'passive': "Real Time Protection",
		'passive description': "Clears debuffs of 2 nearby towers every 2s.",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': [5, 5, 15],
		'upgrade1cost': [70, 105, 140],
		'upgrade2': "Range",
		'upgrade2level': 0,
		'upgrade2amount': 25,
		'upgrade2cost': [70, 105, 140],
		'tier1ability': "Batch Remediation",
		'tier1abilitydesc': "Clear debuffs of 5 nearby towers.",
		'tier1abilityunlocked': false,
		'upgrade3': "Crit Rate",
		'upgrade3level': 0,
		'upgrade3amount': 15,
		'upgrade3cost': [175, 230, 280],
		'upgrade4': "Attack Speed",
		'upgrade4level': 0,
		'upgrade4amount': 0.2,
		'upgrade4cost': [175, 230, 280],
		'tier2ability': "Rapid Response Mitigation",
		'tier2abilitydesc': "Decrease passive activation time to 1s.",
		'tier2abilityunlocked': false,
		'upgrade5': "Damage",
		'upgrade5level': 0,
		'upgrade5amount': [30, 30, 35],
		'upgrade5cost': [230, 315, 385],
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'upgrade6cost': [280, 350, 420],
		'tier3ability': "Network-Wide Remediation",
		'tier3abilitydesc': "Every tower within the range can be cleared of the debuffs.",
		'tier3abilityunlocked': false,
		},
		Tower.SANDBOX_ANALYZER: {
		'name': 'Sandbox Analyzer',
		'isUnlocked': false,
		'waveUnlocked': 36,
		'unlockable': false,
		'cost': 150,
		'server_load': 55,
		'damage': 220,
		'reload_time': 3,
		'range': 1000,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.SINGLE,
		'thumbnail': "res://graphics/ui/tower thumbnails 2/SANDBOX.png",
		'scene': "res://scenes/towers/tower_sandbox_analyzer.tscn",
		'passive': "Increased Damage to Malwares by 20%",
		'passive description': "Traps one enemy in a force cage until it dies, but it cannot target another enemy while occupied.       Nearby enemies become infected as well.",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 2,
		'upgrade1cost': [100, 150, 200],
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.1,
		'upgrade2cost': [100, 150, 200],
		'tier1ability': "Viral Spread",
		'tier1abilitydesc': "Trapped enemy infects up to 2 nearby enemies.",
		'tier1abilityunlocked': false,
		'upgrade3': "Attack Speed",
		'upgrade3level': 0,
		'upgrade3amount': [0.1, 0.1, 0.1],
		'upgrade3cost': [250, 325, 400],
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade4amount': 15,
		'upgrade4cost': [200, 325, 400],
		'tier2ability': "Accelerated Decay",
		'tier2abilitydesc': "Trapped enemy loses health 20% faster.",
		'tier2abilityunlocked': false,
		'upgrade5': "Damage",
		'upgrade5level': 0,
		'upgrade5amount': [4, 5, 5],
		'upgrade5cost': [325, 450, 550],
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'upgrade6cost': [400, 500, 600],
		'tier3ability': "Epidemic Lock",
		'tier3abilitydesc': "Infection cap increased to 5 nearby enemies.",
		'tier3abilityunlocked': false,
		},
		Tower.AI_SECURITY: {
		'name': 'AI Security',
		'isUnlocked': false,
		'waveUnlocked': 28,
		'unlockable': false,
		'cost': 275,
		'server_load': 40,
		'damage': 130,
		'reload_time': 1,
		'range': 350,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.LASER,
		'thumbnail': "res://graphics/ui/tower thumbnails/ai_sec.png",
		'scene': "res://scenes/towers/tower_ai_security.tscn",
		'passive': "AI Lock On",
		'passive description': "Fires a laser on an enemy and continously damage it every 1s. Other enemies in the laser's path also gets damaged.",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': [5, 5, 15],
		'upgrade1cost': [70, 105, 140],
		'upgrade2': "Range",
		'upgrade2level': 0,
		'upgrade2amount': 25,
		'upgrade2cost': [70, 105, 140],
		'tier1ability': "Beam Amplification",
		'tier1abilitydesc': "Increase the laser width by 5x.",
		'tier1abilityunlocked': false,
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade3amount': [5, 5, 15],
		'upgrade3cost': [175, 230, 280],
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade4amount': 15,
		'upgrade4cost': [175, 230, 280],
		'tier2ability': "Execution Protocol",
		'tier2abilitydesc': "Executes enemies upon reaching 10% health.",
		'tier2abilityunlocked': false,
		'upgrade5': "Crit Damage",
		'upgrade5level': 0,
		'upgrade5amount': 25,
		'upgrade5cost': [230, 315, 385],
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'upgrade6cost': [280, 350, 420],
		'tier3ability': "Overclocked Core",
		'tier3abilitydesc': "Laser damage continously increase every second by 10% for upto 100% when hitting the same target.",
		'tier3abilityunlocked': false,
		},
		Tower.DATA_LOSS_PREVENTION: {
		'name': 'DLP',
		'isUnlocked': false,
		'waveUnlocked': 12,
		'unlockable': false,
		'cost': 50,
		'server_load': 25,
		'damage': 0,
		'reload_time': 1.50,
		'range': 1000,
		'crit rate': 0,
		'crit damage': 0,
		'bullet': Bullet.SINGLE,
		'thumbnail': "res://graphics/ui/tower thumbnails 2/DLP.png",
		'scene': "res://scenes/towers/tower_data_loss_prevention.tscn",
		'passive': "Increased Damage to Malwares by 20%",
		'passive description': "Infects enemies and reduces their damage by 35%.",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 2,
		'upgrade1cost': [20, 30, 40],
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.1,
		'upgrade2cost': [20, 30, 40],
		'tier1ability': "Stronger Infection",
		'tier1abilitydesc': "Increases damage reduction from 35% to 50%.",
		'tier1abilityunlocked': false,
		'upgrade3': "Attack Speed",
		'upgrade3level': 0,
		'upgrade3amount': [0.1, 0.1, 0.1],
		'upgrade3cost': [50, 65, 80],
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade4amount': 15,
		'upgrade4cost': [50, 65, 80],
		'tier2ability': "Quarantine Network",
		'tier2abilitydesc': "When a debuffed enemy is hit by DLP again, the debuff spreads to 1 nearby enemy.",
		'tier2abilityunlocked': false,
		'upgrade5': "Damage",
		'upgrade5level': 0,
		'upgrade5amount': [4, 5, 5],
		'upgrade5cost': [65, 90, 110],
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'upgrade6cost': [80, 100, 120],
		'tier3ability': "Kill Switch",
		'tier3abilitydesc': "If a debuffed enemy falls below 20% HP, it has a 30% chance to be instantly deleted when hit by any bullet.",
		'tier3abilityunlocked': false,
		},
		Tower.PATCH: {
		'name': 'PATCH',
		'isUnlocked': false,
		'cost': 0,
		'server_load': 0,
		'damage': 10.0,
		'reload_time': 1,
		'range': 1000,
		'crit rate': 0,
		'crit damage': 0,
		'bullet': Bullet.SINGLE,
		'thumbnail': "res://graphics/ui/tower thumbnails 2/PATCH.png",
		'scene': "res://scenes/towers/tower_patch.tscn",
		}
	}

func calculate_crit_damage(tower_type: int, base_damage: int, crit_chance_buff: int) -> int:
	var tower_data = TOWER_DATA.get(tower_type, {})
	var crit_chance = (tower_data.get("crit rate", 0) + crit_chance_buff) / 100.0
	crit_chance += Offense.multiplied_crit_chance
	var crit_multiplier = tower_data.get("crit damage", 0) / 100.0
	print(crit_chance)
	if randf() < crit_chance:
		return int(base_damage * (1.0 + crit_multiplier))
	return base_damage


# Server visual level (1-6), purely cosmetic: reflects total Offense+Defense+Economy
# upgrades purchased. 70 max upgrades total / 5 steps = 14 upgrades per level.
const SERVER_VISUAL_TOTAL_UPGRADES_MAX: int = 70
const SERVER_VISUAL_UPGRADES_PER_LEVEL: int = 14

func get_server_visual_level() -> int:
	var total := 0
	for lvl in Offense.offense_levels:
		total += lvl
	for lvl in Defense.defense_levels:
		total += lvl
	for lvl in Economy.economy_levels:
		total += lvl
	total = mini(total, SERVER_VISUAL_TOTAL_UPGRADES_MAX)
	return clampi(1 + (total / SERVER_VISUAL_UPGRADES_PER_LEVEL), 1, 6)


var SENTINEL_DATA = {
	Sentinel.ETHICAL: {
		'name': 'Ethical Hacker',
		'isUnlocked': false,
		'cooldown': 15,
		'duration': 3,
		'range': 500,
		'thumbnail': "res://graphics/sentinels/thumbnail/ETHICALHACKER.png",
		'scene': "res://scenes/sentinels/sentinel_ethical_hacker.tscn",
	},
	Sentinel.SYSAD: {
		'name': 'System Administrator',
		'isUnlocked': false,
		'cooldown': 60,
		'range': 0,
		'thumbnail': "res://graphics/sentinels/thumbnail/SYSTEMADMIN.png",
		'scene': "res://scenes/sentinels/sentinel_system_administrator.tscn",
	},
	Sentinel.INTRUSION: {
		'name': 'Intrusion Analyst',
		'isUnlocked': false,
		'cooldown': 30,
		'range': 0,
		'thumbnail': "res://graphics/sentinels/thumbnail/INTRUSIONANALYST.png",
		'scene': "res://scenes/sentinels/sentinel_intrusion_analyst.tscn",
		 },
	Sentinel.SECURITY: {
		'name': 'Security Architect',
		'isUnlocked': false,
		'cooldown': 15,
		'duration': 10,
		'range': 500,
		'thumbnail': "res://graphics/sentinels/thumbnail/SECURITYARCHITECT.png",
		'scene': "res://scenes/sentinels/sentinel_security_architect.tscn",
		},
	Sentinel.MALWARE: {
		'name': 'Malware Analyst',
		'isUnlocked': false,
		'cooldown': 25,
		'duration': 15,
		'range': 500,
		'thumbnail': "res://graphics/sentinels/thumbnail/MALWAREANALYST.png",
		'scene': "res://scenes/sentinels/sentinel_malware_analyst.tscn",
		},
	Sentinel.DECEPTION: {
		'name': 'Deception Analyst',
		'isUnlocked': false,
		'cooldown': 30,
		'duration': 15,
		'range': 500,
		'thumbnail': "res://graphics/sentinels/thumbnail/DECEPTIONANALYST.png",
		'scene': "res://scenes/sentinels/sentinel_deception_analyst.tscn",
		 }
}

var ENEMY_DATA = {
	Enemy.DEFAULT: {
		'health': 20,
		'texture': "uid://biixy5e8v8how",
		'speed': 105,
		'name': "spam",
		'damage': 5,
		'atkspd': 0.5,
		"exp": 2,
		"isMet": true,
		"waveUnlocked": 1},
	Enemy.VIRUS: {
		'health': 40,
		'texture': "uid://c6j3u1ewdc7ry",
		'speed': 100,
		'name': "virus",
		'damage': 10,
		'atkspd': 0.6,
		"exp": 3,
		"isMet": false,
		"waveUnlocked": 4},
	Enemy.ADWARE: {
		'health': 80,
		'texture': "uid://uv3lkpfkcqb1",
		'speed': 105,
		'name': "adware",
		'damage': 12,
		'atkspd': 0.7,
		"exp": 4,
		"isMet": false,
		"waveUnlocked": 8},
	Enemy.WORM: {
		'health': 30,
		'texture': "uid://cq83i85lk0drt",
		'speed': 120,
		'name': "worm",
		'damage': 15,
		'atkspd': 0.8,
		"exp": 5,
		"isMet": false,
		"waveUnlocked": 12},
	Enemy.SPYWARE: {
		'health': 100,
		'texture': "uid://brqrfbf3rnun3",
		'speed': 115,
		'name': "spyware",
		'damage': 35,
		'atkspd': 1,
		"exp": 6,
		"isMet": false,
		"waveUnlocked": 16},
	Enemy.TROJAN: {
		'health': 350,
		'texture': "uid://dg8b5ek5g0byi",
		'speed': 100,
		'name': "trojan",
		'damage': 55,
		'atkspd': 1,
		"exp": 9,
		"isMet": false,
		"waveUnlocked": 24},
	Enemy.BOTNET: {
		'health': 200,
		'texture': "uid://dcx6ley5pknyn",
		'speed': 105,
		'name': "botnet",
		'damage': 55,
		'atkspd': 1.2,
		"exp": 8,
		"isMet": false,
		"waveUnlocked": 19},
	Enemy.CREDS: {
		'health': 20,
		'texture': "uid://ie82cokh85on",
		'speed': 100,
		'name': "creds",
		'damage': 5,
		'atkspd': 1,
		"exp": 9,
		"isMet": false,
		"waveUnlocked": 22},
	Enemy.INSIDERTHREAT: {
		'health': 120,
		'texture': "uid://f3kmwgwtwhby",
		'speed': 110,
		'name': "insiderthreat",
		'damage': 80,
		'atkspd': 1.3,
		"exp": 10,
		"isMet": false,
		"waveUnlocked": 28},
	Enemy.ROOTKIT: {
		'health': 200,
		'texture': "uid://chs1nrp5s1cne",
		'speed': 100,
		'name': "rootkit",
		'damage': 100,
		'atkspd': 1.4,
		"exp": 11,
		"isMet": false,
		"waveUnlocked": 32},
	Enemy.SQL: {
		'health': 150,
		'texture': "uid://diyet18ahl6mf",
		'speed': 118,
		'name': "sql",
		'damage': 120,
		'atkspd': 1.5,
		"exp": 12,
		"isMet": false,
		"waveUnlocked": 34},
	Enemy.DDOS: {
		'health': 500,
		'texture': "uid://bfaik0etx7yif",
		'speed': 95,
		'name': "ddos",
		'damage': 150,
		'atkspd': 1.6,
		"exp": 13,
		"isMet": false,
		"waveUnlocked": 36},
	Enemy.RANSOMWARE: {
		'health': 150,
		'texture': "uid://c654gnfm0an4n",
		'speed': 105,
		'name': "ransomware",
		'damage': 250,
		'atkspd': 1.8,
		"exp": 15,
		"isMet": false,
		"waveUnlocked": 38},
	Enemy.ZERO: {
		'health': 220,
		'texture': "uid://bgewpl0g08iay",
		'speed': 110,
		'name': "zero",
		'damage': 350,
		'atkspd': 2,
		"exp": 16,
		"isMet": false,
		"waveUnlocked": 43},
	Enemy.BOSS1: { # I LOVE YOU
		'health': 5000,
		'texture': "uid://bh62x426nayqs",
		'speed': 100,
		'name': "boss1",
		'damage': 99999,
		'atkspd': 1,
		"exp": 100,
		"isMet": false,
		"waveUnlocked": 10},
	Enemy.BOSS2: { # CONFICKER
		'health': 8000,
		'texture': "uid://btscyncy6p42a",
		'speed': 100,
		'name': "boss2",
		'damage': 99999,
		'atkspd': 1.2,
		"exp": 145,
		"isMet": false,
		"waveUnlocked": 20},
	Enemy.BOSS3: { # WANNA CRY
		'health': 10000,
		'texture': "uid://b7ojhou6ogpwf",
		'speed': 100,
		'name': "boss3",
		'damage': 99999,
		'atkspd': 1.5,
		"exp": 200,
		"isMet": false,
		"waveUnlocked": 30},
	Enemy.BOSS4: { # NOT PETYA
		'health': 12000,
		'texture': "uid://he2k33y4efo3",
		'speed': 100,
		'name': "boss4",
		'damage': 99999,
		'atkspd': 2,
		"exp": 325,
		"isMet": false,
		"waveUnlocked": 40},
	Enemy.BOSS5: { # MY DOOM
		'health': 15000,
		'texture': "uid://bsbw28l1xncts",
		'speed': 100,
		'name': "boss5",
		'damage': 99999,
		'atkspd': 2,
		"exp": 450,
		"isMet": false,
		"waveUnlocked": 50},
	Enemy.BOSS6: { # MY TROJAN
		'health': 20000,
		'texture': "uid://djls2dab0ajxy",
		'speed': 100,
		'name': "boss6",
		'damage': 99999,
		'atkspd': 2,
		"exp": 450,
		"isMet": false,
		"waveUnlocked": 50}
}

var ads_visible := false:
	set(value):
		if ads_visible == value:
			return
		ads_visible = value
		ads_visible_changed.emit()
var active_adware := 0:
	set(value):
		active_adware = value
		active_adware_changed.emit()
var active_ransomware := 0:
	set(value):
		active_ransomware = value
		active_ransomware_changed.emit()
		
var currentserverload: int = 0:
	set(value):
		currentserverload = value
		server_load_changed.emit()

		for node in get_tree().get_nodes_in_group("TowerCard"):
			if node.has_method("toggle_active"):
				node.toggle_active(Data.money)
		
var maxserverload := default_system_load:
	set(value):
		maxserverload = value
		server_load_changed.emit()

		for node in get_tree().get_nodes_in_group("TowerCard"):
			if node.has_method("toggle_active"):
				node.toggle_active(Data.money)
				
var money := default_money:
	set(value):
		money = value

		var ui = get_tree().get_first_node_in_group("UI")
		if ui:
			ui.update_stats(money, health)

		for node in get_tree().get_nodes_in_group("TowerCard"):
			if node.has_method("toggle_active"):
				node.toggle_active(money)
var health: float = default_health:
	set(value):
		var previous_health := health
		if Data.is_unli_health:
			health = value
		else:
			health = clamp(value, 0, max_health)

		var ui = get_tree().get_first_node_in_group('UI')
		if ui:
			ui.update_stats(money, health)
		if Data.is_vmmode and health < previous_health:
			get_tree().call_group("vmmode_session", "_on_server_damaged", previous_health - health)
		if health <= 0:
			if backup_server_placed:
				activate_backup_server()
			elif Data.is_vmmode:
				get_tree().call_group("vmmode_session", "_on_server_health_depleted")
			else:
				ui.get_node("GameOver").visible = true
				get_tree().paused = true

var ABILITY_DATA = {
	Ability.FIREWALL: {
		'health': 500,
	}
}


func reset_game():
	money = default_money
	currentserverload = 0
	max_health = default_health
	health = default_health
	clear_notpetya_enemy_speed_effect()


func _initialize_base_tower_stats() -> void:
	#Store the original base stats for all towers
	if not base_tower_stats.is_empty():
		return # Already initialized
	
	for tower_enum in Tower.values():
		var tower_data = TOWER_DATA[tower_enum]
		base_tower_stats[tower_enum] = {
			'damage': tower_data.get('damage', 0),
			'reload_time': tower_data.get('reload_time', 0),
			'range': tower_data.get('range', 0),
			'crit rate': tower_data.get('crit rate', 0),
			'crit damage': tower_data.get('crit damage', 0),
			'explosion_radius': tower_data.get('explosion_radius', 0),
		}


func _backup_tower_upgrades() -> void:
	# Always update the backup 
	before_tower_upgrades.clear()
	
	for tower_enum in Tower.values():
		var tower_data = TOWER_DATA[tower_enum]
		before_tower_upgrades[tower_enum] = {
			'upgrade1level': tower_data.get('upgrade1level', 0),
			'upgrade2level': tower_data.get('upgrade2level', 0),
			'upgrade3level': tower_data.get('upgrade3level', 0),
			'upgrade4level': tower_data.get('upgrade4level', 0),
			'upgrade5level': tower_data.get('upgrade5level', 0),
			'upgrade6level': tower_data.get('upgrade6level', 0),
			'damage': tower_data.get('damage', 0),
			'reload_time': tower_data.get('reload_time', 0),
			'range': tower_data.get('range', 0),
			'crit rate': tower_data.get('crit rate', 0),
			'crit damage': tower_data.get('crit damage', 0),
			'explosion_radius': tower_data.get('explosion_radius', 0),
		}


func _reset_tower_upgrades_to_base() -> void:
	#Reset all tower upgrades to base values,called when entering sandbox mode or when resetting the game
	for tower_enum in Tower.values():
		var tower_data = TOWER_DATA[tower_enum]
		# Reset all upgrade levels to 0
		tower_data['upgrade1level'] = 0
		tower_data['upgrade2level'] = 0
		tower_data['upgrade3level'] = 0
		tower_data['upgrade4level'] = 0
		tower_data['upgrade5level'] = 0
		tower_data['upgrade6level'] = 0
		
		_reset_tower_to_base(tower_enum)


func _reset_tower_to_base(tower_enum: int) -> void:
	"""Reset a specific tower to its base stats using stored base stats"""
	# Initialize base stats if not already done
	if base_tower_stats.is_empty():
		_initialize_base_tower_stats()
	
	var tower_data = TOWER_DATA[tower_enum]
	var base = base_tower_stats.get(tower_enum, {})
	
	tower_data['damage'] = base.get('damage', tower_data.get('damage', 0))
	tower_data['reload_time'] = base.get('reload_time', tower_data.get('reload_time', 0))
	tower_data['range'] = base.get('range', tower_data.get('range', 0))
	tower_data['crit rate'] = base.get('crit rate', tower_data.get('crit rate', 0))
	tower_data['crit damage'] = base.get('crit damage', tower_data.get('crit damage', 0))
	if base.has('explosion_radius'):
		tower_data['explosion_radius'] = base['explosion_radius']


func _restore_tower_upgrades() -> void:
	#Restore tower upgrades from backup when exiting sandbox mode
	if before_tower_upgrades.is_empty():
		return
	
	for tower_enum in Tower.values():
		if not before_tower_upgrades.has(tower_enum):
			continue
		
		var backup = before_tower_upgrades[tower_enum]
		var tower_data = TOWER_DATA[tower_enum]
		
		tower_data['upgrade1level'] = backup.get('upgrade1level', 0)
		tower_data['upgrade2level'] = backup.get('upgrade2level', 0)
		tower_data['upgrade3level'] = backup.get('upgrade3level', 0)
		tower_data['upgrade4level'] = backup.get('upgrade4level', 0)
		tower_data['upgrade5level'] = backup.get('upgrade5level', 0)
		tower_data['upgrade6level'] = backup.get('upgrade6level', 0)
		tower_data['damage'] = backup.get('damage', 0)
		tower_data['reload_time'] = backup.get('reload_time', 0)
		tower_data['range'] = backup.get('range', 0)
		tower_data['crit rate'] = backup.get('crit rate', 0)
		tower_data['crit damage'] = backup.get('crit damage', 0)
		if backup.has('explosion_radius'):
			tower_data['explosion_radius'] = backup['explosion_radius']


func _apply_vmmode_fixed_tower_upgrades(map_number: int) -> void:
	for tower_enum in Tower.values():
		var tower_data: Dictionary = TOWER_DATA[tower_enum]
		if not tower_data.has("upgrade1"):
			continue
		var remaining_budget: int = map_number
		for tier in range(3):
			if remaining_budget <= 0:
				break
			var slot_a := tier * 2 + 1
			var slot_b := tier * 2 + 2
			var cap_a: int = tower_data.get("upgrade%dcost" % slot_a, []).size()
			var cap_b: int = tower_data.get("upgrade%dcost" % slot_b, []).size()
			var tier_cap: int = max(cap_a, cap_b)
			if tier_cap <= 0:
				continue
			var tier_level: int = mini(remaining_budget, tier_cap)
			if tower_data.has("upgrade%d" % slot_a) and cap_a > 0:
				_apply_tower_upgrade_slot_to_level(tower_enum, slot_a, mini(tier_level, cap_a))
			if tower_data.has("upgrade%d" % slot_b) and cap_b > 0:
				_apply_tower_upgrade_slot_to_level(tower_enum, slot_b, mini(tier_level, cap_b))
			remaining_budget -= tier_level


func _apply_tower_upgrade_slot_to_level(tower_enum: int, slot_index: int, target_level: int) -> void:
	var tower_data: Dictionary = TOWER_DATA[tower_enum]
	var upgrade_name: String = tower_data.get("upgrade%d" % slot_index, "")
	var amount_def = tower_data.get("upgrade%damount" % slot_index, 0)

	for level in range(1, target_level + 1):
		var amount = amount_def
		if typeof(amount_def) == TYPE_ARRAY:
			amount = amount_def[clampi(level - 1, 0, amount_def.size() - 1)]

		match upgrade_name:
			"Damage":
				tower_data["damage"] += amount
			"Attack Speed":
				tower_data["reload_time"] = max(0.1, tower_data["reload_time"] - amount)
			"Range":
				tower_data["range"] += amount
			"Explosion Radius":
				tower_data["explosion_radius"] += amount
			"Crit Rate":
				tower_data["crit rate"] += amount
			"Crit Damage":
				tower_data["crit damage"] += amount

	tower_data["upgrade%dlevel" % slot_index] = target_level

var multiplier: int = 1
var notpetya_enemy_speed_multiplier: float = 1.0

func clear_notpetya_enemy_speed_effect() -> void:
	notpetya_enemy_speed_multiplier = 1.0

func apply_notpetya_enemy_speed_effect(multiplier: float) -> void:
	notpetya_enemy_speed_multiplier = multiplier

var server_points: int = 1:
	set(value):
		server_points = value
		var server = get_tree().get_first_node_in_group("server")
		if server:
			if server_points > 0:
				server.toggle_particle(true)
			if server_points == 0:
				server.toggle_particle(false)

var default_level_pool: float = 50
var player_level: int = 1
var experience: int = 0:
	set(value):
		experience = value
		var ui = get_tree().get_first_node_in_group("UI")
		# Cap at level 100
		if player_level >= 100:
			player_level = 100
			experience = int(default_level_pool) # Keep bar eexp full
			if ui:
				ui.update_experience(experience, player_level, default_level_pool)
			return
		
		if player_level == 3 and GameDialogueManager.is_level_3 and !Data.is_sandbox and !Data.is_vmmode and Data.current_wave == 3:
			GameDialogueManager.show_dialogue_server_upgrade()
		
		while experience >= default_level_pool:
			experience -= default_level_pool
			player_level += 1
			server_points += 1
			if player_level <= 51:
				default_level_pool += 8
			else:
				default_level_pool += 16
			# Stop leveling to 101 if we hit lvl 100
			if player_level >= 100:
				player_level = 100
				experience = int(default_level_pool)
				break

		if ui:
			ui.update_experience(experience, player_level, default_level_pool)


func activate_backup_server():
	backup_server_placed = false
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.start_backup_server_cooldown()
		ui.update_skill3_locked()
	for card in get_tree().get_nodes_in_group("TowerCard"):
		card.toggle_active(money)
	backup_server_invincible = true
	health = 1
	

	for tower in get_tree().get_nodes_in_group("Towers"):
		if tower.scene_file_path == "res://scenes/towers/tower_backup_server.tscn":
			tower.queue_free()
			break

	var server = get_tree().get_first_node_in_group("server")
	if server:
		server.activate_backup_server()

func update_wave_unlocks() -> void:
	for tower_enum in Tower.values():
		var tower_data = TOWER_DATA[tower_enum]

		if tower_data.has("waveUnlocked") and tower_data.has("unlockable"):
			if current_wave >= tower_data["waveUnlocked"]:
				tower_data["unlockable"] = true

	for enemy_enum in Enemy.values():
		var enemy_data = ENEMY_DATA[enemy_enum]

		if enemy_data.has("waveUnlocked"):
			if current_wave >= enemy_data["waveUnlocked"]:
				enemy_data["isMet"] = true

	for map_number in VM_MAP_DATA.keys():
		var map_data = VM_MAP_DATA[map_number]

		if map_data.has("unlock_wave") and not map_data.get("unlocked", false):
			if current_wave >= map_data["unlock_wave"]:
				map_data["unlocked"] = true
