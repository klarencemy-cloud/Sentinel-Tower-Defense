extends Node
signal active_adware_changed
signal active_ransomware_changed
var default_health: float = 100.0
var max_health: float = default_health
var default_money: int = 3000
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

var is_server_cyber_shown: bool = false
signal toggle_server_scene # to toggle server upgrade visibility
signal change_challenge() # for vm


signal deactivate(selected_sentinel: Data.Sentinel) # for sentinel

# "before" variables to store the original values before entering sandbox mode
var before_total_money: int
var before_total_health: float
var before_max_server_load: int
var before_owned_towers: Dictionary
var before_server_points: int
var before_player_level: int
var before_total_experience: int


var bullet_angle: Vector2

var wave_started: bool = false


var before_level_index: int
var current_level_index: int = 0 # map count 0 = level 1

var checkpoint_wave: int = 0 # checkpoint count
var current_wave: int = 1 # wave count
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
var damage_reduction: float = 0


var is_tower_placeable: bool = true
var is_placing_tower: bool = false

var owned_towers: Dictionary = {}
var free_towers: Dictionary = {}
enum Tower {SPAM_FILTER, ANTIVIRUS, DATA_LOSS_PREVENTION, QUARANTINE_CANNON, IDPS, BACKUP_SERVER, SANDBOX_ANALYZER, AD_BLOCKER, ACCESS_CONTROL_SYSTEM, ENDPOINT_PROTECTION, AI_SECURITY}
enum Bullet {SINGLE, FIRE, MORTAR_EXPLOSION, LASER}
enum Sentinel {ETHICAL, SYSAD, INTRUSION, SECURITY, MALWARE, DECEPTION}
enum Enemy {DEFAULT, VIRUS, ADWARE, WORM, SPYWARE, TROJAN, BOTNET, CREDS, INSIDERTHREAT, ROOTKIT, SQL, DDOS, RANSOMWARE, ZERO, BOSS1, BOSS2, BOSS3, BOSS4, BOSS5}
enum Ability {FIREWALL}
var TOWER_DATA = {
	Tower.SPAM_FILTER: {
		'name': 'Spam Filter',
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
		'cost': 60,
		'server_load': 30,
		'damage': 1,
		'reload_time': 2,
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
		'upgrade1amount': 1,
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
		'upgrade5amount': 1,
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
		'cost': 550,
		'damage': 5000,
		'server_load': 65,
		'thumbnail': "res://graphics/ui/tower thumbnails 2/BACKUP.png",
		'scene': "res://scenes/towers/tower_backup_server.tscn",
		'bullet': Bullet.FIRE,
		'upgradeable': false,
		},
	Tower.AD_BLOCKER: {
		'name': 'Ad Blocker',
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
		}
	}

func calculate_crit_damage(tower_type: int, base_damage: int) -> int:
	var tower_data = TOWER_DATA.get(tower_type, {})
	var crit_chance = tower_data.get("crit rate", 0) / 100.0
	var crit_multiplier = tower_data.get("crit damage", 0) / 100.0
	if randf() < crit_chance:
		return int(base_damage * (1.0 + crit_multiplier))
	return base_damage


var SENTINEL_DATA = {
	Sentinel.ETHICAL: {
		'name': 'Ethical Hacker',
		'cooldown': 3,
		'range': 1000,
		'thumbnail': "res://graphics/sentinels/thumbnail/ETHICALHACKER.png",
		'scene': "res://scenes/sentinels/sentinel_ethical_hacker.tscn",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 1,
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.2,
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade3amount': 1,
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade4amount': 15,
		'upgrade5': "Crit Damage",
		'upgrade5level': 0,
		'upgrade5amount': 25,
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'tier1abilityunlocked': false,
		'tier2abilityunlocked': false,
		'tier3abilityunlocked': false, },
	Sentinel.SYSAD: {
		'name': 'System Administrator',
		'cooldown': 60,
		'range': 1000,
		'thumbnail': "res://graphics/sentinels/thumbnail/SYSTEMADMIN.png",
		'scene': "res://scenes/sentinels/sentinel_system_administrator.tscn",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 1,
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.2,
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade3amount': 1,
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade4amount': 15,
		'upgrade5': "Crit Damage",
		'upgrade5level': 0,
		'upgrade5amount': 25,
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'tier1abilityunlocked': false,
		'tier2abilityunlocked': false,
		'tier3abilityunlocked': false, },
	Sentinel.INTRUSION: {
		'name': 'Intrusion Analyst',
		'cooldown': 30,
		'range': 1000,
		'thumbnail': "res://graphics/sentinels/thumbnail/INTRUSIONANALYST.png",
		'scene': "res://scenes/sentinels/sentinel_intrusion_analyst.tscn",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 1,
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.2,
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade3amount': 1,
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade4amount': 15,
		'upgrade5': "Crit Damage",
		'upgrade5level': 0,
		'upgrade5amount': 25,
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'tier1abilityunlocked': false,
		'tier2abilityunlocked': false,
		'tier3abilityunlocked': false, },
	Sentinel.SECURITY: {
		'name': 'Security Architect',
		'cooldown': 15,
		'duration': 10,
		'range': 1000,
		'thumbnail': "res://graphics/sentinels/thumbnail/SECURITYARCHITECT.png",
		'scene': "res://scenes/sentinels/sentinel_security_architect.tscn",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 1,
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.2,
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade3amount': 1,
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade4amount': 15,
		'upgrade5': "Crit Damage",
		'upgrade5level': 0,
		'upgrade5amount': 25,
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'tier1abilityunlocked': false,
		'tier2abilityunlocked': false,
		'tier3abilityunlocked': false, },
	Sentinel.MALWARE: {
		'name': 'Malware Analyst',
		'cooldown': 3,
		'range': 1000,
		'thumbnail': "res://graphics/sentinels/thumbnail/MALWAREANALYST.png",
		'scene': "res://scenes/sentinels/sentinel_malware_analyst.tscn",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 1,
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.2,
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade3amount': 1,
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade4amount': 15,
		'upgrade5': "Crit Damage",
		'upgrade5level': 0,
		'upgrade5amount': 25,
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'tier1abilityunlocked': false,
		'tier2abilityunlocked': false,
		'tier3abilityunlocked': false, },
	Sentinel.DECEPTION: {
		'name': 'Deception Analyst',
		'cooldown': 3,
		'range': 1000,
		'thumbnail': "res://graphics/sentinels/thumbnail/DECEPTIONANALYST.png",
		'scene': "res://scenes/sentinels/sentinel_deception_analyst.tscn",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 1,
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.2,
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade3amount': 1,
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade4amount': 15,
		'upgrade5': "Crit Damage",
		'upgrade5level': 0,
		'upgrade5amount': 25,
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'tier1abilityunlocked': false,
		'tier2abilityunlocked': false,
		'tier3abilityunlocked': false, }
}

var ENEMY_DATA = {
	Enemy.DEFAULT: {
		'health': 20,
		'texture': "uid://biixy5e8v8how",
		'speed': 105,
		'name': "spam",
		'damage': 5,
		'atkspd': 0.5,
		"exp": 2},
	Enemy.VIRUS: {
		'health': 40,
		'texture': "uid://c6j3u1ewdc7ry",
		'speed': 100,
		'name': "virus",
		'damage': 10,
		'atkspd': 0.6,
		"exp": 3},
	Enemy.ADWARE: {
		'health': 80,
		'texture': "uid://uv3lkpfkcqb1",
		'speed': 105,
		'name': "adware",
		'damage': 12,
		'atkspd': 0.7,
		"exp": 4},
	Enemy.WORM: {
		'health': 30,
		'texture': "uid://cq83i85lk0drt",
		'speed': 120,
		'name': "worm",
		'damage': 15,
		'atkspd': 0.8,
		"exp": 5},
	Enemy.SPYWARE: {
		'health': 100,
		'texture': "uid://brqrfbf3rnun3",
		'speed': 115,
		'name': "spyware",
		'damage': 35,
		'atkspd': 1,
		"exp": 6},
	Enemy.TROJAN: {
		'health': 350,
		'texture': "uid://dg8b5ek5g0byi",
		'speed': 100,
		'name': "trojan",
		'damage': 55,
		'atkspd': 1,
		"exp": 9},
	Enemy.BOTNET: {
		'health': 200,
		'texture': "uid://dcx6ley5pknyn",
		'speed': 105,
		'name': "botnet",
		'damage': 55,
		'atkspd': 1.2,
		"exp": 8},
	Enemy.CREDS: {
		'health': 20,
		'texture': "uid://ie82cokh85on",
		'speed': 100,
		'name': "creds",
		'damage': 5,
		'atkspd': 1,
		"exp": 9},
	Enemy.INSIDERTHREAT: {
		'health': 120,
		'texture': "uid://f3kmwgwtwhby",
		'speed': 110,
		'name': "insiderthreat",
		'damage': 80,
		'atkspd': 1.3,
		"exp": 10},
	Enemy.ROOTKIT: {
		'health': 200,
		'texture': "uid://chs1nrp5s1cne",
		'speed': 100,
		'name': "rootkit",
		'damage': 100,
		'atkspd': 1.4,
		"exp": 11},
	Enemy.SQL: {
		'health': 150,
		'texture': "uid://diyet18ahl6mf",
		'speed': 118,
		'name': "sql",
		'damage': 120,
		'atkspd': 1.5,
		"exp": 12},
	Enemy.DDOS: {
		'health': 500,
		'texture': "uid://bfaik0etx7yif",
		'speed': 95,
		'name': "ddos",
		'damage': 150,
		'atkspd': 1.6,
		"exp": 13},
	Enemy.RANSOMWARE: {
		'health': 150,
		'texture': "uid://c654gnfm0an4n",
		'speed': 105,
		'name': "ransomware",
		'damage': 250,
		'atkspd': 1.8,
		"exp": 15},
	Enemy.ZERO: {
		'health': 220,
		'texture': "uid://bgewpl0g08iay",
		'speed': 110,
		'name': "zero",
		'damage': 350,
		'atkspd': 2,
		"exp": 16},
	Enemy.BOSS1: { # I LOVE YOU
		'health': 5000,
		'texture': "uid://bh62x426nayqs",
		'speed': 100,
		'name': "boss1",
		'damage': 99999,
		'atkspd': 1,
		"exp": 100},
	Enemy.BOSS2: { # CONFICKER
		'health': 8000,
		'texture': "uid://btscyncy6p42a",
		'speed': 100,
		'name': "boss2",
		'damage': 99999,
		'atkspd': 1.2,
		"exp": 145},
	Enemy.BOSS3: { # WANNA CRY
		'health': 10000,
		'texture': "uid://b7ojhou6ogpwf",
		'speed': 100,
		'name': "boss3",
		'damage': 99999,
		'atkspd': 1.5,
		"exp": 200},
	Enemy.BOSS4: { # NOT PETYA
		'health': 12000,
		'texture': "uid://he2k33y4efo3",
		'speed': 100,
		'name': "boss4",
		'damage': 99999,
		'atkspd': 2,
		"exp": 325},
	Enemy.BOSS5: { # MY DOOM
		'health': 15000,
		'texture': "uid://bsbw28l1xncts",
		'speed': 100,
		'name': "boss5",
		'damage': 99999,
		'atkspd': 2,
		"exp": 450}
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
		if Data.is_unli_health:
			health = value
		else:
			health = clamp(value, 0, max_health)
		
		var ui = get_tree().get_first_node_in_group('UI')
		if ui:
			ui.update_stats(money, health)
		if health <= 0:
			if backup_server_placed:
				activate_backup_server()
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

var multiplier: int = 1
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
		
		if player_level == 3 and GameDialogueManager.is_level_3 and !Data.is_sandbox and !Data.current_wave > 3:
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

			print("level_pool", default_level_pool)
		
		if ui:
			ui.update_experience(experience, player_level, default_level_pool)
			
func activate_backup_server():
	backup_server_placed = false
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
