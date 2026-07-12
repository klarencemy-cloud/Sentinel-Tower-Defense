extends Node
signal active_adware_changed
signal active_ransomware_changed
var default_health: float = 100.0
var default_money: int = 200
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

signal toggle_server_scene # to toggle server upgrade visibility

signal change_challenge() # for vm

# "before" variables to store the original values before entering sandbox mode
var before_total_money: int
var before_total_health: float
var before_max_server_load: int #
var before_owned_towers: Dictionary
var before_server_points: int
var before_player_level: int
var before_total_experience: int


var wave_started: bool = false


var before_level_index: int
var current_level_index: int = 0 # map count 0 = level 1

var owned_towers: Dictionary = {}
var free_towers: Dictionary = {}
enum Tower {BASIC, BLAST, MORTAR, SPAM_FILTER, QUARANTINE_CANNON, IDPS}
enum Bullet {SINGLE, FIRE, MORTAR_EXPLOSION}
enum Enemy {DEFAULT, VIRUS, ADWARE, WORM, SPYWARE, TROJAN, BOTNET, CREDS, INSIDERTHREAT, ROOTKIT, SQL, DDOS, RANSOMWARE, ZERO, BOSS1, BOSS2, BOSS3, BOSS4, BOSS5}

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
		'thumbnail': "res://graphics/ui/tower thumbnails/acs.png",
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
		'thumbnail': "res://graphics/ui/tower thumbnails/soar.png",
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
		'thumbnail': "res://graphics/ui/tower thumbnails/sandbox.png",
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
		'thumbnail': "res://graphics/ui/tower thumbnails/spam_filter.png",
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
		'thumbnail': "res://graphics/ui/tower thumbnails/quarantine.png",
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
		'thumbnail': "res://graphics/ui/tower thumbnails/idps.png",
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
	Enemy.DEFAULT: {
		'health': 20,
		'texture': "uid://biixy5e8v8how",
		'speed': 105,
		'name': "spam",
		'damage': 5,
		"exp": 2},
	Enemy.VIRUS: {
		'health': 40,
		'texture': "uid://c6j3u1ewdc7ry",
		'speed': 100,
		'name': "virus",
		'damage': 10,
		"exp": 3},
	Enemy.ADWARE: {
		'health': 80,
		'texture': "uid://uv3lkpfkcqb1",
		'speed': 105,
		'name': "adware",
		'damage': 12,
		"exp": 4},
	Enemy.WORM: {
		'health': 30,
		'texture': "uid://cq83i85lk0drt",
		'speed': 120,
		'name': "worm",
		'damage': 15,
		"exp": 5},
	Enemy.SPYWARE: {
		'health': 100,
		'texture': "uid://brqrfbf3rnun3",
		'speed': 115,
		'name': "spyware",
		'damage': 35,
		"exp": 6},
	Enemy.TROJAN: {
		'health': 350,
		'texture': "uid://dg8b5ek5g0byi",
		'speed': 100,
		'name': "trojan",
		'damage': 55,
		"exp": 9},
	Enemy.BOTNET: {
		'health': 200,
		'texture': "uid://dcx6ley5pknyn",
		'speed': 105,
		'name': "botnet",
		'damage': 55,
		"exp": 8},
	Enemy.CREDS: {
		'health': 20,
		'texture': "uid://ie82cokh85on",
		'speed': 100,
		'name': "creds",
		'damage': 5,
		"exp": 9},
	Enemy.INSIDERTHREAT: {
		'health': 120,
		'texture': "uid://f3kmwgwtwhby",
		'speed': 110,
		'name': "insiderthreat",
		'damage': 80,
		"exp": 10},
	Enemy.ROOTKIT: {
		'health': 200,
		'texture': "uid://chs1nrp5s1cne",
		'speed': 100,
		'name': "rootkit",
		'damage': 100,
		"exp": 11},
	Enemy.SQL: {
		'health': 150,
		'texture': "uid://diyet18ahl6mf",
		'speed': 118,
		'name': "sql",
		'damage': 120,
		"exp": 12},
	Enemy.DDOS: {
		'health': 500,
		'texture': "uid://bfaik0etx7yif",
		'speed': 95,
		'name': "ddos",
		'damage': 150,
		"exp": 13},
	Enemy.RANSOMWARE: {
		'health': 150,
		'texture': "uid://c654gnfm0an4n",
		'speed': 105,
		'name': "ransomware",
		'damage': 250,
		"exp": 15},
	Enemy.ZERO: {
		'health': 220,
		'texture': "uid://bgewpl0g08iay",
		'speed': 110,
		'name': "zero",
		'damage': 350,
		"exp": 16},
	Enemy.BOSS1: { # I LOVE YOU
		'health': 15000,
		'texture': "uid://bh62x426nayqs",
		'speed': 100,
		'name': "boss1",
		'damage': 100,
		"exp": 100},
	Enemy.BOSS2: { # CONFICKER
		'health': 30000,
		'texture': "uid://btscyncy6p42a",
		'speed': 100,
		'name': "boss2",
		'damage': 200,
		"exp": 145},
	Enemy.BOSS3: { # WANNA CRY
		'health': 50000,
		'texture': "uid://b7ojhou6ogpwf",
		'speed': 100,
		'name': "boss3",
		'damage': 320,
		"exp": 200},
	Enemy.BOSS4: { # NOT PETYA
		'health': 90000,
		'texture': "uid://he2k33y4efo3",
		'speed': 100,
		'name': "boss4",
		'damage': 200,
		"exp": 325},
	Enemy.BOSS5: { # MY DOOM
		'health': 110000,
		'texture': "uid://bsbw28l1xncts",
		'speed': 100,
		'name': "boss5",
		'damage': 200,
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
var current_wave: int = 1 # wave count

func reset_game():
	money = default_money
	currentserverload = 0

var multiplier: int = 1
var server_points: int = 0:
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
		
		if player_level == 3 and GameDialogueManager.is_level_3:
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
