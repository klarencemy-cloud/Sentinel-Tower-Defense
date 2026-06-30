extends Control

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

# var checks if upgrades are max level
var offense_1_counter: int = 0
var offense_2_counter: int = 0
var offense_3_counter: int = 0

var children: Array = []
var base_names: Array = ["Upgrade1", "Upgrade2", "Upgrade3"]
var letters: Array = ["a", "a", "a"]
var target_names: Array = ["", "", ""]

var offenses: Array = []
var counts: Array = []
var counters: Array = [0, 0, 0]

var dmg_real_cost: int = 1 #price
var speed_real_cost: int = 1 #price
var crit_real_cost: int = 1 #price
var dmg_max_level: int = 0
var speed_max_level: int = 0
var crit_max_level: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offenses = [offense_1, offense_2, offense_3]

	for i in range(3):
		children.append(offenses[i].get_children())
		target_names[i] = base_names[i] + letters[i] 

	# Counts total texture rect
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

	
func _on_offense_upgrade_1_pressed() -> void:
	_upgrade(0) 


func _on_offense_upgrade_2_pressed() -> void:
	_upgrade(1)


func _on_offense_upgrade_3_pressed() -> void:
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
						Offense._inc_dmg()
						_damage_max_level()
					1:
						Offense._tower_speed()
						_speed_max_level()
					2:
						Offense._crit_chance()
						_crit_max_level()

				counters[index] += 1
				letters[index] = char(letters[index].unicode_at(0) + 1) # Increment letter a to b and so on
				target_names[index] = base_names[index] + letters[index] # Combine base name and incremented letter "Upgrade1a" to "Upgrade1b"
				break
	else:
		print("Max Level")


func _damage_max_level() -> void:
	dmg_max_level += 1
	if dmg_max_level == offense_1_count:
		damage_cost.text = "Max"


func _speed_max_level() -> void:
	speed_max_level += 1
	if speed_max_level == offense_2_count:
		speed_cost.text = "Max"


func _crit_max_level() -> void:
	crit_max_level += 1
	if crit_max_level == offense_3_count:
		crit_cost.text = "Max"