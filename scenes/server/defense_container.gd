extends Control

signal refresh_pts

@onready var defense_1: TextureButton = $Defense1
@onready var defense_2: TextureButton = $Defense2
@onready var defense_3: TextureButton = $Defense3
@onready var defense_4: TextureButton = $Defense4
@onready var server_health_cost: Label = $Defense2/Cost
@onready var sentinel_cost: Label = $Defense4/Cost
@onready var armor_cost: Label = $Defense1/Cost
@onready var skill_cd_cost: Label = $Defense3/Cost

# Count of TextureRect which is total upgrade counts.
var defense1_count: int = 0
var defense2_count: int = 0
var defense3_count: int = 0
var defense4_count: int = 0

var children: Array = []
var base_names: Array = ["Upgrade1", "Upgrade2", "Upgrade3", "Upgrade4"]
var letters: Array = ["a", "a", "a", "a"]
var target_names: Array = ["", "", "", ""]

var defenses: Array = []
var counts: Array = []

var armor_real_cost: int = 1
var skill_cd_real_cost: int = 1

var server_health_slot_price: int = 2
var sentinel_slot_price: int = 2

const price_increment1: int = 2
const price_increment2: int = 4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	defenses = [defense_1, defense_2, defense_3, defense_4]

	for i in range(4):
		children.append(defenses[i].get_children())
		target_names[i] = base_names[i] + letters[i]

	for child in defense_1.get_children():
		if child is TextureRect:
			defense1_count += 1
	for child in defense_2.get_children():
		if child is TextureRect:
			defense2_count += 1
	for child in defense_3.get_children():
		if child is TextureRect:
			defense3_count += 1
	for child in defense_4.get_children():
		if child is TextureRect:
			defense4_count += 1
	
	counts = [defense1_count, defense2_count, defense3_count, defense4_count]

	server_health_slot_price = Defense.server_health_slot_price
	sentinel_slot_price = Defense.sentinel_slot_price

	if Data.is_sandbox:
		Defense._sandbox_mode()

	_update_upgrades()

func _update_upgrades() -> void:
	for i in range(4):
		var level = Defense.defense_levels[i]
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
	var level = Defense.defense_levels[index]
	var count = counts[index]
	
	if Defense.maxed[index]:
		match index:
			0: armor_cost.text = "Max"
			1: server_health_cost.text = "Max"
			2: skill_cd_cost.text = "Max"
			3: sentinel_cost.text = "Max"
		return
	
	# Not maxed — show current cost
	match index:
		0: armor_cost.text = "Cost: " + str(armor_real_cost)
		1: server_health_cost.text = "Cost: " + str(server_health_slot_price)
		2: skill_cd_cost.text = "Cost: " + str(skill_cd_real_cost)
		3: sentinel_cost.text = "Cost: " + str(sentinel_slot_price)


func _on_defense_upgrade_1_pressed() -> void: # Armor
	UISound.play_click()
	_upgrade(0)


func _on_defense_upgrade_2_pressed() -> void: # Skill Slot
	UISound.play_click()
	_upgrade(1)


func _on_defense_upgrade_3_pressed() -> void: # Skill CD
	UISound.play_click()
	_upgrade(2)


func _on_defense_upgrade_4_pressed() -> void: # Sentinel Deployed
	UISound.play_click()
	_upgrade(3)


func _upgrade(index: int) -> void:
	var level = Defense.defense_levels[index]
	var count = counts[index]
	
	if level >= count:
		print("Max Level")
		return
	
	match index:
		0:
			if Data.server_points < armor_real_cost:
				return
			Data.server_points -= armor_real_cost
			Defense._armor_damage_reduction()
			_armor_max_level()
		1:
			if Data.server_points < server_health_slot_price:
				return
			Data.server_points -= server_health_slot_price
			Defense._server_health()
			_skill_price_increment()
		2:
			if Data.server_points < skill_cd_real_cost:
				return
			Data.server_points -= skill_cd_real_cost
			Defense._skill_cooldown_reduction()
			_skill_cd_max_level()
		3:
			if Data.server_points < sentinel_slot_price:
				return
			Data.server_points -= sentinel_slot_price
			Defense._sentinel_deployed_add()  
			_sentinel_slot_increment()

	refresh_pts.emit()
	
	# Update visual
	for child in children[index]:
		if child.name == target_names[index]:
			child.texture = load("res://graphics/upgrade/Upgraded.png")
			letters[index] = char(letters[index].unicode_at(0) + 1)
			target_names[index] = base_names[index] + letters[index]
			break
	
	# Check if max level after upgrade
	if Defense.defense_levels[index] >= counts[index]:
		Defense.maxed[index] = true
		_update_cost_label(index)


func _armor_max_level() -> void:
	if Defense.defense_levels[0] >= defense1_count:
		armor_cost.text = "Max"
		Defense.maxed[0] = true


func _skill_cd_max_level() -> void:
	if Defense.defense_levels[2] >= defense3_count:
		skill_cd_cost.text = "Max"
		Defense.maxed[2] = true


func _skill_price_increment() -> void:
	var times_bought = Defense.defense_levels[1]
	server_health_slot_price = 2 + (times_bought * price_increment1)
	Defense.server_health_slot_price = server_health_slot_price
	
	if server_health_slot_price >= 8:
		server_health_cost.text = "Max"
		Defense.maxed[1] = true
		Defense.server_health_slot_price = 8  # Cap it
	else:
		server_health_cost.text = "Cost: " + str(server_health_slot_price)


func _sentinel_slot_increment() -> void:
	var times_bought = Defense.defense_levels[3]
	sentinel_slot_price = 2 + (times_bought * price_increment2)
	Defense.sentinel_slot_price = sentinel_slot_price
	
	if sentinel_slot_price >= 14:
		sentinel_cost.text = "Max"
		Defense.maxed[3] = true
		Defense.sentinel_slot_price = 14 
	else:
		sentinel_cost.text = "Cost: " + str(sentinel_slot_price)