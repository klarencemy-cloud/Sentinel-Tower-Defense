extends Node

var is_sandbox: bool = false
var is_unli_money: bool = false
var is_unli_health: bool = false
var is_unli_senti_cap: bool = false
var is_maxed_lvl: bool = false

var before_total_money: int
var before_total_health: int

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
		'bullet': Bullet.SINGLE,
		'thumbnail': "res://graphics/ui/tower thumbnails/basic.png",
		'scene': "res://scenes/towers/single_tower.tscn",
		'upgrade1' : "Damage",
		'upgrade2' : "Attack Speed",
		'upgrade3' : "Damage",
		'upgrade4' : "Crit Rate",
		'upgrade5' : "Crit Damage",
		'upgrade6' : "Range"},

	Tower.BLAST: {
		'name': 'Blaster',
		'cost': 30,
		'damage' : 3,
		'reload_time': 1.5,
		'range': 50,
		'bullet': Bullet.FIRE,
		'thumbnail': "res://graphics/ui/tower thumbnails/blaster.png",
		'scene': "res://scenes/towers/blaster_tower.tscn",
		'upgrade1' : "Damage",
		'upgrade2' : "Attack Speed",
		'upgrade3' : "Damage",
		'upgrade4' : "Attack Speed",
		'upgrade5' : "Attack Speed",
		'upgrade6' : "Range"},
		
	Tower.MORTAR: {
		'name': 'Mortar',
		'cost': 30,
		'reload_time': 2.0,
		'damage' : 5,
		'range': 200,
		'bullet': Bullet.MORTAR_EXPLOSION,
		'thumbnail': "res://graphics/ui/tower thumbnails/mortar.png",
		'scene': "res://scenes/towers/mortar_tower.tscn",
		'upgrade1' : "Damage",
		'upgrade2' : "Attack Speed",
		'upgrade3' : "Damage",
		'upgrade4' : "Crit Rate",
		'upgrade5' : "Crit Damage",
		'upgrade6' : "Attack Speed"}
		}
		
var ENEMY_DATA = {
	Enemy.DEFAULT: {'health': 3, 'texture': "res://graphics/Ships/ship_0004.png", 'speed': 20},
	Enemy.FAST: {'health': 3, 'texture': "res://graphics/Ships/ship_0007.png", 'speed': 50},
	Enemy.STRONG: {'health': 6, 'texture': "res://graphics/Ships/ship_0000.png", 'speed': 25},
	Enemy.BIG: {'health': 20, 'texture': "res://graphics/Ships/ship_0015.png", 'speed': 15}}



var money := 200:
	set(value):
		money = value

		var ui = get_tree().get_first_node_in_group('UI')
		if ui:
			ui.update_stats(money, health)
		for tower_card in get_tree().get_nodes_in_group('TowerCard'):
			tower_card.toggle_active(money)
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
var current_wave: int
