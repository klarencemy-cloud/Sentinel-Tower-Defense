extends Node

var is_sandbox: bool = false
var is_unli_money: bool = false
var is_unli_health: bool = false
var is_unli_senti_cap: bool = false
var is_maxed_lvl: bool = false

var before_total_money: int
var before_total_health: int

var current_level_index := 0

enum Tower {BASIC, BLAST, MORTAR}
enum Bullet {SINGLE, FIRE, MORTAR_EXPLOSION}
enum Enemy {DEFAULT, FAST, STRONG, BIG}

var TOWER_DATA = {
	Tower.BASIC: {
		'name': 'Basic',
		'cost': 20,
		'damage' : 2,
		'reload_time': 1.0,
		'range': 100,
		'crit rate' : 0,
		'crit damage': 50,
		'bullet': Bullet.SINGLE,
		'thumbnail': "res://graphics/ui/tower thumbnails/basic.png",
		'scene': "res://scenes/towers/single_tower.tscn",
		'upgrade1' : "Damage",
		'upgrade1level' : 0,
		'upgrade2' : "Attack Speed",
		'upgrade2level' : 0,
		'upgrade3' : "Damage",
		'upgrade3level' : 0,
		'upgrade4' : "Crit Rate",
		'upgrade4level' : 0,
		'upgrade5' : "Crit Damage",
		'upgrade5level' : 0,
		'upgrade6' : "Range",
		'upgrade6level' : 0,},

	Tower.BLAST: {
		'name': 'Blaster',
		'cost': 30,
		'damage' : 3,
		'reload_time': 1.5,
		'range': 50,
		'crit rate': 0,
		'crit damage': 50,
		'bullet': Bullet.FIRE,
		'thumbnail': "res://graphics/ui/tower thumbnails/blaster.png",
		'scene': "res://scenes/towers/blaster_tower.tscn",
		'upgrade1' : "Damage",
		'upgrade1level' : 0,
		'upgrade2' : "Attack Speed",
		'upgrade2level' : 0,
		'upgrade3' : "Damage",
		'upgrade3level' : 0,
		'upgrade4' : "Attack Speed",
		'upgrade4level' : 0,
		'upgrade5' : "Attack Speed",
		'upgrade5level' : 0,
		'upgrade6' : "Range",
		'upgrade6level' : 0,},
		
	Tower.MORTAR: {
		'name': 'Mortar',
		'cost': 30,
		'reload_time': 2.0,
		'damage' : 5,
		'range': 200,
		'crit rate' : 0,
		'crit damage': 50,
		'bullet': Bullet.MORTAR_EXPLOSION,
		'thumbnail': "res://graphics/ui/tower thumbnails/mortar.png",
		'scene': "res://scenes/towers/mortar_tower.tscn",
		'upgrade1' : "Damage",
		'upgrade1level' : 0,
		'upgrade2' : "Attack Speed",
		'upgrade2level' : 0,
		'upgrade3' : "Damage",
		'upgrade3level' : 0,
		'upgrade4' : "Crit Rate",
		'upgrade4level' : 0,
		'upgrade5' : "Crit Damage",
		'upgrade5level' : 0,
		'upgrade6' : "Attack Speed",
		'upgrade6level' : 0,}
		}
		
var ENEMY_DATA = {
	Enemy.DEFAULT: {'health': 3, 'texture': "res://graphics/Ships/ship_0004.png", 'speed': 20},
	Enemy.FAST: {'health': 3, 'texture': "res://graphics/Ships/ship_0007.png", 'speed': 50},
	Enemy.STRONG: {'health': 6, 'texture': "res://graphics/Ships/ship_0000.png", 'speed': 25},
	Enemy.BIG: {'health': 20, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 15}}

var UPGRADE_DATA = {
	"Damage": 1,
	"Attack Speed": 0.2,
	"Range" : 25,
	"Crit Rate": 15,
	"Crit Damage": 25
}


var money := 200:
	set(value):
		money = value

		var ui = get_tree().get_first_node_in_group('UI')
		if ui:
			ui.update_stats(money, health)
var health := 100:
	set(value):
		health = value
			
		var ui = get_tree().get_first_node_in_group('UI')
		if ui:
			ui.update_stats(money, health)
		if health <= 0:
			ui.get_node("GameOver").visible = true
			get_tree().paused = true
var checkpoint_wave: int = 0
var current_wave: int = 0
