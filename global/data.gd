extends Node
signal active_adware_changed
signal active_ransomware_changed
var default_health: float = 100.0
var default_money: int = 200
var default_system_load: int = 200
var is_sandbox: bool = false
var is_vmmode: bool = false
var is_unli_money: bool = false
var is_unli_health: bool = false
var is_unli_senti_cap: bool = false
var is_maxed_lvl: bool = false
signal server_load_changed
signal ads_visible_changed

signal toggle_server_scene # to toggle server upgrade visibility

signal change_challenge() # for vm

var before_total_money: int # sandbox save total money para hindi ma overwrite yung sa main story
var before_total_health: float # sandbox save total health para hindi ma overwrite yung sa main story
var before_max_server_load: int # sandbox save total server load capaccity para hindi ma overwrite yung sa main story

var before_level_index: int
var current_level_index: int = 0 # map count 0 = level 1

var owned_towers: Dictionary = {}
var free_towers: Dictionary = {}
enum Tower {BASIC, BLAST, MORTAR, SPAM_FILTER, QUARANTINE_CANNON, IDPS}
enum Bullet {SINGLE, FIRE, MORTAR_EXPLOSION}
enum Enemy {DEFAULT, VIRUS, ADWARE, WORM, SPYWARE, BOTNET, CREDS, INSIDERTHREAT, ROOTKIT, SQL, DDOS, RANSOMWARE, ZERO, BOSS1}

var TOWER_DATA = {
	Tower.BASIC: {
		'name': 'Basic',
		'cost': 20,
		'server_load': 15,
		'damage': 2,
		'reload_time': 1.0,
		'range': 1000,
		'crit rate': 0,
		'crit damage': 50,
		'explosion_radius': 100,
		'bullet': Bullet.SINGLE,
		'thumbnail': "res://graphics/ui/tower thumbnails/basic.png",
		'scene': "res://scenes/towers/single_tower.tscn",
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

	Tower.BLAST: {
		'name': 'Blaster',
		'cost': 30,
		'damage': 3,
		'reload_time': 1.5,
		'server_load': 25,
		'range': 50,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.FIRE,
		'thumbnail': "res://graphics/ui/tower thumbnails/blaster.png",
		'scene': "res://scenes/towers/blaster_tower.tscn",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 1,
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.2,
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade3amount': 1,
		'upgrade4': "Attack Speed",
		'upgrade4level': 0,
		'upgrade4amount': 0.2,
		'upgrade5': "Attack Speed",
		'upgrade5level': 0,
		'upgrade5amount': 0.2,
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'tier1abilityunlocked': false,
		'tier2abilityunlocked': false,
		'tier3abilityunlocked': false, },
		
	Tower.MORTAR: {
		'name': 'Mortar',
		'cost': 30,
		'reload_time': 2.0,
		'server_load': 50,
		'damage': 5,
		'explosion_radius': 100,
		'crit rate': 0,
		'crit damage': 50,
		'range': 200,
		'bullet': Bullet.MORTAR_EXPLOSION,
		'thumbnail': "res://graphics/ui/tower thumbnails/mortar.png",
		'scene': "res://scenes/towers/mortar_tower.tscn",
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
		'upgrade6': "Attack Speed",
		'upgrade6level': 0,
		'upgrade6amount': 0.2,
		'tier1abilityunlocked': false,
		'tier2abilityunlocked': false,
		'tier3abilityunlocked': false, },
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
		'thumbnail': "res://graphics/ui/tower thumbnails/basic.png",
		'scene': "res://scenes/towers/tower_spamfilter.tscn",
		'passive': "Ricochet",
		'passive description': "Bullet bounces to the nearby enemy that deals 50% of the original damage.",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 1,
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.2,
		'tier1ability': "+1 Bounce",
		'tier1abilitydesc': "Bullets bounce an additional time.",
		'tier1abilityunlocked': false,
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade3amount': 1,
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade4amount': 15,
		'tier2ability': "Bounce Damage+",
		'tier2abilitydesc': "Ricocheted bullets' damage increased from 50% to 75%.",
		'tier2abilityunlocked': false,
		'upgrade5': "Crit Damage",
		'upgrade5level': 0,
		'upgrade5amount': 25,
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'tier3ability': "Infinite Recursion",
		'tier3abilitydesc': "Bullets has 50% chance to ricochet on kill.",
		'tier3abilityunlocked': false, },
	Tower.QUARANTINE_CANNON: {
		'name': 'Quarantine Cannon',
		'cost': 60,
		'server_load': 30,
		'damage': 1,
		'reload_time': 3,
		'range': 200,
		'crit rate': 0,
		'crit damage': 50,
		'explosion_radius': 100,
		'bullet': Bullet.MORTAR_EXPLOSION,
		'thumbnail': "res://graphics/ui/tower thumbnails/mortar.png",
		'scene': "res://scenes/towers/tower_quarantinecannon.tscn",
		'passive': "Freeze",
		'passive description': "Freeze enemies on hit for 1s.",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade1amount': 1,
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade2amount': 0.2,
		'tier1ability': "Freeze+",
		'tier1abilitydesc': "Increase Frozen duration to 1.5s.",
		'tier1abilityunlocked': false,
		'upgrade3': "Crit Rate",
		'upgrade3level': 0,
		'upgrade3amount': 15,
		'upgrade4': "Crit Damage",
		'upgrade4level': 0,
		'upgrade4amount': 25,
		'tier2ability': "Thermal Lag",
		'tier2abilitydesc': "Enemies are slowed for 2s after being unfrozen.",
		'tier2abilityunlocked': false,
		'upgrade5': "Damage",
		'upgrade5level': 0,
		'upgrade5amount': 1,
		'upgrade6': "Explosion Radius",
		'upgrade6level': 0,
		'upgrade6amount': 20,
		'tier3ability': "Frozen Vulnerability",
		'tier3abilitydesc': "Frozen enemies take 15% more damage when frozen.",
		'tier3abilityunlocked': false, },
		Tower.IDPS: {
		'name': 'IDPS',
		'cost': 30,
		'damage': 0,
		'reload_time': 2.5,
		'server_load': 25,
		'range': 150,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.FIRE,
		'thumbnail': "res://graphics/ui/tower thumbnails/blaster.png",
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
		'upgrade2': "Range",
		'upgrade2level': 0,
		'upgrade2amount': 25,
		'upgrade3': "Attack Speed",
		'upgrade3level': 0,
		'upgrade3amount': 0.2,
		'upgrade4': "Attack Speed",
		'upgrade4level': 0,
		'upgrade4amount': 0.2,
		'upgrade5': "Attack Speed",
		'upgrade5level': 0,
		'upgrade5amount': 0.2,
		'upgrade6': "Range",
		'upgrade6level': 0,
		'upgrade6amount': 25,
		'tier1abilityunlocked': false,
		'tier2abilityunlocked': false,
		'tier3abilityunlocked': false, }
	}

func calculate_crit_damage(tower_type: int, base_damage: int) -> int:
	var tower_data = TOWER_DATA.get(tower_type, {})
	var crit_chance = tower_data.get("crit rate", 0) / 100.0
	var crit_multiplier = tower_data.get("crit damage", 0) / 100.0
	if randf() < crit_chance:
		return int(base_damage * (1.0 + crit_multiplier))
	return base_damage

var ENEMY_DATA = {
	Enemy.DEFAULT: {'health': 20, 'texture': "res://graphics/Ships/ship_0004.png", 'speed': 105, 'name': "spam", 'damage': 5, "exp": 5},
	Enemy.VIRUS: {'health': 40, 'texture': "res://graphics/Ships/ship_0007.png", 'speed': 100, 'name': "virus", 'damage': 10, "exp": 5},
	Enemy.ADWARE: {'health': 80, 'texture': "res://graphics/Ships/ship_0007.png", 'speed': 105, 'name': "adware", 'damage': 12, "exp": 5},
	Enemy.WORM: {'health': 30, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 120, 'name': "worm", 'damage': 15, "exp": 5},
	Enemy.SPYWARE: {'health': 100, 'texture': "res://graphics/Ships/ship_0000.png", 'speed': 115, 'name': "spyware", 'damage': 35, "exp": 5},
	Enemy.BOTNET: {'health': 200, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 105, 'name': "botnet", 'damage': 55, "exp": 5},
	Enemy.CREDS: {'health': 20, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 100, 'name': "creds", 'damage': 5, "exp": 5},
	Enemy.INSIDERTHREAT: {'health': 120, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 110, 'name': "insiderthreat", 'damage': 80, "exp": 5},
	Enemy.ROOTKIT: {'health': 200, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 100, 'name': "rootkit", 'damage': 100, "exp": 5},
	Enemy.SQL: {'health': 150, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 118, 'name': "sql", 'damage': 120, "exp": 5},
	Enemy.DDOS: {'health': 500, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 95, 'name': "ddos", 'damage': 150, "exp": 5},
	Enemy.RANSOMWARE: {'health': 150, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 105, 'name': "ransomware", 'damage': 250}, "exp": 5,
	Enemy.ZERO: {'health': 220, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 110, 'name': "zero", 'damage': 350, "exp": 5},
	Enemy.BOSS1: {'health': 15000, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 100, 'name': "boss1", 'damage': 100, "exp": 5}
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
var maxserverload := default_system_load
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
		health = value
			
		var ui = get_tree().get_first_node_in_group('UI')
		if ui:
			ui.update_stats(money, health)
		if health <= 0:
			ui.get_node("GameOver").visible = true
			get_tree().paused = true

var checkpoint_wave: int = 0 # checkpoint count
var current_wave: int = 0 # wave count

func reset_game():
	money = 200
	currentserverload = 0

var multiplier: int = 1
var server_points: int = 30:
	set(value):
		server_points = value
		var server = get_tree().get_first_node_in_group("server")
		if server_points > 0:
			server.toggle_particle(true)
		if server_points == 0:
			server.toggle_particle(false)


var default_level_pool: float = 100
var player_level: int = 1
var experience: int = 0:
	set(value):
		experience = value
		while experience >= default_level_pool:
			experience -= default_level_pool
			player_level += 1
			server_points += 1
			default_level_pool += default_level_pool * .5
			print("maxxxxxx", default_level_pool)
		var ui = get_tree().get_first_node_in_group("UI")
		if ui:
			ui.update_experience(experience, player_level, default_level_pool)
