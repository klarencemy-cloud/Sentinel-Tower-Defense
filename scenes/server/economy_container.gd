@tool
extends Control

@onready var economy_1: TextureButton = $Economy1
@onready var economy_2: TextureButton = $Economy2
@onready var economy_3: TextureButton = $Economy3
@onready var gold_cost: Label = $Economy1/Cost
@onready var exp_rate_cost: Label = $Economy2/Cost
@onready var server_load_cost: Label = $Economy3/Cost

# Count of TextureRect which is total upgrade counts.
var economy_1_count: int = 0
var economy_2_count: int = 0
var economy_3_count: int = 0

# var checks if upgrades are max level
var economy_1_counter: int = 0
var economy_2_counter: int = 0
var economy_3_counter: int = 0

var children: Array = []
var base_names: Array = ["Upgrade1", "Upgrade2", "Upgrade3"]
var letters: Array = ["a", "a", "a"]
var target_names: Array = ["", "", ""]

var economs: Array = []
var counts: Array = []
var counters: Array = [0, 0, 0]

var gold_real_cost: int = 1 #price
var gold_max_level: int = 0
var exp_rate_real_cost: int = 1 #price
var exp_rate_max_level: int = 0
var server_load_real_cost: int = 1 #price
var server_load_max_level: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	economs = [economy_1, economy_2, economy_3]

	for i in range(3):
		children.append(economs[i].get_children())
		target_names[i] = base_names[i] + letters[i] 

	# Counts total texture rect
	for child in economy_1.get_children():
		if child is TextureRect:
			economy_1_count += 1
	
	for child in economy_2.get_children():
		if child is TextureRect:
			economy_2_count += 1

	for child in economy_3.get_children():
		if child is TextureRect:
			economy_3_count += 1
	
	counts = [economy_1_count, economy_2_count, economy_3_count]

	
func _on_economy_upgrade_1_pressed() -> void:
	_upgrade(0) 


func _on_economy_upgrade_2_pressed() -> void:
	_upgrade(1)


func _on_economy_upgrade_3_pressed() -> void:
	_upgrade(2)


func _upgrade(index: int) -> void:
	var counter = counters[index]
	var count = counts[index]
	
	if counter < count: # checks if max level
		for child in children[index]:
			if child.name == target_names[index]:
				child.texture = load("res://graphics/upgrade/Upgraded.png")

				match index:
					0:
						Economy._gold_drop()
						_gold_max_level()
					1:
						Economy._exp_rate()
						_exp_rate_max_level()
					2:
						Economy._server_load()
						_server_load_max_level()

				counters[index] += 1
				letters[index] = char(letters[index].unicode_at(0) + 1) # Increment letter a to b and so on
				target_names[index] = base_names[index] + letters[index] # Combine base name and incremented letter "Upgrade1a" to "Upgrade1b"
				break
	else:
		print("Max Level")


func _gold_max_level() -> void:
	gold_max_level += 1
	if gold_max_level >= 6:
		gold_real_cost = 2
		gold_cost.text = "Cost: " + str(gold_real_cost)
	if gold_max_level == economy_1_count:
		gold_cost.text = "Max"


func _exp_rate_max_level() -> void:
	exp_rate_max_level += 1
	if exp_rate_max_level >= 6:
		exp_rate_real_cost = 2
		exp_rate_cost.text = "Cost: " + str(exp_rate_real_cost)
	if exp_rate_max_level == economy_2_count:
		exp_rate_cost.text = "Max"


func _server_load_max_level() -> void:
	server_load_max_level += 1
	if server_load_max_level >= 6:
		server_load_real_cost = 2
		server_load_cost.text = "Cost: " + str(server_load_real_cost)
	if server_load_max_level == economy_3_count:
		server_load_cost.text = "Max"
