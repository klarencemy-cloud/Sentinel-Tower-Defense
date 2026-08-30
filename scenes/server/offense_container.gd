extends Control

signal refresh_pts

@onready var offense_1: TextureButton = $Offense1
@onready var offense_2: TextureButton = $Offense2
@onready var offense_3: TextureButton = $Offense3
@onready var damage_cost: Label = $Offense1/Cost
@onready var speed_cost: Label = $Offense2/Cost
@onready var crit_cost: Label = $Offense3/Cost

# Count of TextureRect which is total upgrade counts.
var offense_1_count: int = 0
var offense_2_count: int = 0
var offense_3_count: int = 0

# var offense_1_counter: int = 0
# var offense_2_counter: int = 0
# var offense_3_counter: int = 0

var children: Array = []
var base_names: Array = ["Upgrade1", "Upgrade2", "Upgrade3"]
var letters: Array = ["a", "a", "a"]
var target_names: Array = ["", "", ""]

var offenses: Array = []
var counts: Array = []
# var counters: Array = [0, 0, 0]

var dmg_real_cost: int = 1 # price
var speed_real_cost: int = 1 # price
var crit_real_cost: int = 1 # price

# var dmg_max_level: int = 0
# var speed_max_level: int = 0
# var crit_max_level: int = 0

var maxed: Array[bool] = [false, false, false]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offenses = [offense_1, offense_2, offense_3]

	for i in range(3):
		children.append(offenses[i].get_children())
		target_names[i] = base_names[i] + letters[i]

	# Count total TextureRects (visual slots)
	for child in offense_1.get_children():
		if child is TextureRect:
			offense_1_count += 1
	
	for child in offense_2.get_children():
		if child is TextureRect:
			offense_2_count += 1

	for child in offense_3.get_children():
		if child is TextureRect:
			offense_3_count += 1
	
	counts = [offense_1_count, offense_2_count, offense_3_count]

	if Data.is_sandbox: # SANDBOX MODE!!!!!!
		Offense._sandbox_mode() # Server Upgrade for SANDBOX MODE

	_update_upgrades() # Initial update to reflect current levels and maxed states


func _update_upgrades() -> void:
	for i in range(3):
		var level = Offense.offense_levels[i]
		var count = counts[i]
		
		maxed[i] = Offense.maxed[i]
		
		if level >= count:
			match i:
				0: damage_cost.text = "Max"
				1: speed_cost.text = "Max"
				2: crit_cost.text = "Max"
		
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


func _on_offense_upgrade_1_pressed() -> void:
	UISound.play_click()
	_upgrade(0)


func _on_offense_upgrade_2_pressed() -> void:
	UISound.play_click()
	_upgrade(1)


func _on_offense_upgrade_3_pressed() -> void:
	UISound.play_click()
	_upgrade(2)


func _upgrade(index: int) -> void:
	if Data.is_vmmode:
		return
	var level = Offense.offense_levels[index]
	var count = counts[index]
	
	if level < count: # checks if max level
		match index:
			0:
				if Data.server_points < dmg_real_cost:
					return
				Data.server_points -= dmg_real_cost
				Offense._inc_dmg()
				_damage_max_level()
			1:
				if Data.server_points < speed_real_cost:
					return
				Data.server_points -= speed_real_cost
				Offense._tower_speed()
				_speed_max_level()
			2:
				if Data.server_points < crit_real_cost:
					return
				Data.server_points -= crit_real_cost
				Offense._crit_chance()
				_crit_max_level()

		refresh_pts.emit()
		for child in children[index]:
			if child.name == target_names[index]:
				child.texture = load("res://graphics/upgrade/Upgraded.png")
				
				# CHANGED: Increment persistent level in Offense autoload
				Offense.offense_levels[index] += 1
				
				letters[index] = char(letters[index].unicode_at(0) + 1)
				target_names[index] = base_names[index] + letters[index]
				break
	else:
		print("Max Level")


func _damage_max_level() -> void:
	if Offense.offense_levels[0] + 1 >= counts[0]:
		damage_cost.text = "Max"
		Offense.maxed[0] = true
		maxed[0] = true


func _speed_max_level() -> void:
	if Offense.offense_levels[1] + 1 >= counts[1]:
		speed_cost.text = "Max"
		Offense.maxed[1] = true
		maxed[1] = true


func _crit_max_level() -> void:
	if Offense.offense_levels[2] + 1 >= counts[2]:
		crit_cost.text = "Max"
		Offense.maxed[2] = true
		maxed[2] = true
