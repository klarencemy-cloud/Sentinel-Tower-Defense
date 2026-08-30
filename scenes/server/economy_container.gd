extends Control

signal refresh_pts

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

var children: Array = []
var base_names: Array = ["Upgrade1", "Upgrade2", "Upgrade3"]
var letters: Array = ["a", "a", "a"]
var target_names: Array = ["", "", ""]

var economs: Array = []
var counts: Array = []

var gold_real_cost: int = 1
var exp_rate_real_cost: int = 1
var server_load_real_cost: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	economs = [economy_1, economy_2, economy_3]

	for i in range(3):
		children.append(economs[i].get_children())
		target_names[i] = base_names[i] + letters[i] 

	# Count total TextureRects
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

	gold_real_cost = Economy.gold_cost_tier
	exp_rate_real_cost = Economy.exp_cost_tier
	server_load_real_cost = Economy.server_cost_tier

	if Data.is_sandbox:
		Economy._sandbox_mode()

	_update_upgrades()


func _update_upgrades() -> void:
	for i in range(3):
		var level = Economy.economy_levels[i]
		var count = counts[i]

		_update_cost_label(i)

		var current_letter = "a"
		for j in range(level):
			var target_name = base_names[i] + current_letter
			for child in children[i]:
				if child.name == target_name and child is TextureRect:
					child.texture = load("res://graphics/upgrade/Upgraded.png")
					break
			current_letter = char(current_letter.unicode_at(0) + 1)

		letters[i] = current_letter
		target_names[i] = base_names[i] + letters[i]


func _update_cost_label(index: int) -> void:
	var level = Economy.economy_levels[index]
	var count = counts[index]
	
	if level >= count:
		match index:
			0: gold_cost.text = "Max"
			1: exp_rate_cost.text = "Max"
			2: server_load_cost.text = "Max"
		return
	
	match index:
		0: gold_cost.text = "Cost: " + str(gold_real_cost)
		1: exp_rate_cost.text = "Cost: " + str(exp_rate_real_cost)
		2: server_load_cost.text = "Cost: " + str(server_load_real_cost)


func _on_economy_upgrade_1_pressed() -> void:
	UISound.play_click()
	_upgrade(0)


func _on_economy_upgrade_2_pressed() -> void:
	UISound.play_click()
	_upgrade(1)


func _on_economy_upgrade_3_pressed() -> void:
	UISound.play_click()
	_upgrade(2)


func _upgrade(index: int) -> void:
	if Data.is_vmmode:
		return
	var level = Economy.economy_levels[index]
	var count = counts[index]
	
	if level >= count:
		print("Max Level")
		return
	
	match index:
		0:
			if Data.server_points < gold_real_cost:
				return
			Data.server_points -= gold_real_cost
			Economy._gold_drop()
			_gold_max_level()
		1:
			if Data.server_points < exp_rate_real_cost:
				return
			Data.server_points -= exp_rate_real_cost
			Economy._exp_rate()
			_exp_rate_max_level()
		2:
			if Data.server_points < server_load_real_cost:
				return
			Data.server_points -= server_load_real_cost
			Economy._server_load()
			_server_load_max_level()

	refresh_pts.emit() #refreshg server points display

	# Update the image tier
	for child in children[index]:
		if child.name == target_names[index]:
			child.texture = load("res://graphics/upgrade/Upgraded.png")
			letters[index] = char(letters[index].unicode_at(0) + 1)
			target_names[index] = base_names[index] + letters[index]
			break

	if Economy.economy_levels[index] >= counts[index]: # checks if max level reached after upgrade
		match index:
			0: 
				gold_cost.text = "Max"
				Economy.maxed[0] = true
			1: 
				exp_rate_cost.text = "Max"
				Economy.maxed[1] = true
			2: 
				server_load_cost.text = "Max"
				Economy.maxed[2] = true


func _gold_max_level() -> void:
	var level = Economy.economy_levels[0]
	# checks every 2 level to increase the cost of the next upgrade

	match level:
		2:
			gold_real_cost = 2
			Economy.gold_cost_tier = 2
			gold_cost.text = "Cost: " + str(gold_real_cost)
		4:
			gold_real_cost = 3
			Economy.gold_cost_tier = 3
			gold_cost.text = "Cost: " + str(gold_real_cost)
		6:
			gold_real_cost = 4
			Economy.gold_cost_tier = 4
			gold_cost.text = "Cost: " + str(gold_real_cost)


func _exp_rate_max_level() -> void:
	var level = Economy.economy_levels[1]
	
	match level:
		2:
			exp_rate_real_cost = 2
			Economy.exp_cost_tier = 2
			exp_rate_cost.text = "Cost: " + str(exp_rate_real_cost)
		4:
			exp_rate_real_cost = 3
			Economy.exp_cost_tier = 3
			exp_rate_cost.text = "Cost: " + str(exp_rate_real_cost)
		6:
			exp_rate_real_cost = 4
			Economy.exp_cost_tier = 4
			exp_rate_cost.text = "Cost: " + str(exp_rate_real_cost)


func _server_load_max_level() -> void:
	var level = Economy.economy_levels[2]
	
	match level:
		2:
			server_load_real_cost = 2
			Economy.server_cost_tier = 2
			server_load_cost.text = "Cost: " + str(server_load_real_cost)
		4:
			server_load_real_cost = 3
			Economy.server_cost_tier = 3
			server_load_cost.text = "Cost: " + str(server_load_real_cost)
		6:
			server_load_real_cost = 4
			Economy.server_cost_tier = 4
			server_load_cost.text = "Cost: " + str(server_load_real_cost)
