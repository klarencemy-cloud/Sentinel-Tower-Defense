extends Node

var default_health: int = 100
var default_money: int = 200
var default_system_load: int = 200

var is_sandbox: bool = false
var is_unli_money: bool = false
var is_unli_health: bool = false
var is_unli_senti_cap: bool = false
var is_maxed_lvl: bool = false
signal server_load_changed

var before_total_money: int # sandbox save total money para hindi ma overwrite yung sa main story
var before_total_health: int # sandbox save total health para hindi ma overwrite yung sa main story
var before_max_server_load: int # sandbox save total server load capaccity para hindi ma overwrite yung sa main story

var before_level_index: int
var current_level_index: int = 0 # map count 0 = level 1

enum Tower {BASIC, BLAST, MORTAR, SPAM_FILTER}
enum Bullet {SINGLE, FIRE, MORTAR_EXPLOSION}
enum Enemy {DEFAULT, ADWARE, SPYWARE, CREDS, WORM, BOTNET}

var TOWER_DATA = {
	Tower.BASIC: {
		'name': 'Basic',
		'cost': 20,
		'server_load': 15,
		'damage': 2,
		'reload_time': 1.0,
		'range': 100,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.SINGLE,
		'thumbnail': "res://graphics/ui/tower thumbnails/basic.png",
		'scene': "res://scenes/towers/single_tower.tscn",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade5': "Crit Damage",
		'upgrade5level': 0,
		'upgrade6': "Range",
		'upgrade6level': 0, },

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
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade4': "Attack Speed",
		'upgrade4level': 0,
		'upgrade5': "Attack Speed",
		'upgrade5level': 0,
		'upgrade6': "Range",
		'upgrade6level': 0, },
		
	Tower.MORTAR: {
		'name': 'Mortar',
		'cost': 30,
		'reload_time': 2.0,
		'server_load': 50,
		'damage': 5,
		'range': 200,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.MORTAR_EXPLOSION,
		'thumbnail': "res://graphics/ui/tower thumbnails/mortar.png",
		'scene': "res://scenes/towers/mortar_tower.tscn",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'upgrade5': "Crit Damage",
		'upgrade5level': 0,
		'upgrade6': "Attack Speed",
		'upgrade6level': 0, },
	Tower.SPAM_FILTER: {
		'name': 'Spam Filter',
		'cost': 45,
		'server_load': 15,
		'damage': 2,
		'reload_time': 1,
		'range': 1000,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.SINGLE,
		'thumbnail': "res://graphics/ui/tower thumbnails/basic.png",
		'scene': "res://scenes/towers/single_tower.tscn",
		'passive': "Ricochet",
		'passive description': "Bullet bounces to the nearby enemy that deals 50% of the original damage.",
		'upgrade1': "Damage",
		'upgrade1level': 0,
		'upgrade2': "Attack Speed",
		'upgrade2level': 0,
		'tier1ability': "+1 Bounce",
		'tier1abilitydesc': "Bullets bounce an additional time.",
		'upgrade3': "Damage",
		'upgrade3level': 0,
		'upgrade4': "Crit Rate",
		'upgrade4level': 0,
		'tier2ability': "Bounce Damage+",
		'tier2abilitydesc': "Ricocheted bullets' damage increased from 50% to 75%.",
		'upgrade5': "Crit Damage",
		'upgrade5level': 0,
		'upgrade6': "Range",
		'upgrade6level': 0,
		'tier3ability': "Infinite Recursion",
		'tier3abilitydesc': "Bullets has 50% chance to ricochet on kill.", }
	}
		
var ENEMY_DATA = {
	Enemy.DEFAULT: {'health': 3, 'texture': "res://graphics/Ships/ship_0004.png", 'speed': 20, 'name': "spam"},
	Enemy.ADWARE: {'health': 3, 'texture': "res://graphics/Ships/ship_0007.png", 'speed': 50, 'name': "adware"},
	Enemy.SPYWARE: {'health': 6, 'texture': "res://graphics/Ships/ship_0000.png", 'speed': 25, 'name': "spyware"},
	Enemy.CREDS: {'health': 20, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 15, 'name': "creds"},
	Enemy.BOTNET: {'health': 20, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 15, 'name': "botnet"},
	Enemy.WORM: {'health': 20, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 100, 'name': "worm"}

}

var UPGRADE_DATA = {
	"Damage": 1,
	"Attack Speed": 0.2,
	"Range": 25,
	"Crit Rate": 15,
	"Crit Damage": 25
}

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
var health := default_health:
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
