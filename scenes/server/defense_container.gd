extends Control

@onready var defense_1: TextureButton = $Defense1
@onready var defense_2: TextureButton = $Defense2
@onready var defense_3: TextureButton = $Defense3
@onready var defense_4: TextureButton = $Defense4


# Count of TextureRect which is total upgrade counts.
var defense1_count: int = 0
var defense2_count: int = 0
var defense3_count: int = 0
var defense4_count: int = 0

# var checks if upgrades are max level
var defense1_counter: int = 0
var defense2_counter: int = 0
var defense3_counter: int = 0
var defense4_counter: int = 0

var children: Array = []
var base_names: Array = ["Upgrade1", "Upgrade2", "Upgrade3", "Upgrade4"]
var letters: Array = ["a", "a", "a", "a"]
var target_names: Array = ["", "", "", ""]

var defenses: Array = []
var counts: Array = []
var counters: Array = [0, 0, 0, 0]

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

	
func _on_defense_upgrade_1_pressed() -> void:
	_upgrade(0)


func _on_defense_upgrade_2_pressed() -> void:
	_upgrade(1)


func _on_defense_upgrade_3_pressed() -> void:
	_upgrade(2)


func _on_defense_upgrade_4_pressed() -> void:
	_upgrade(3)


func _upgrade(index: int) -> void:
	var counter = counters[index]
	var count = counts[index]
	
	if counter < count:
		for child in children[index]:
			if child.name == target_names[index]:
				child.texture = load("res://graphics/upgrade/Upgraded.png")
				
				match index:
					0:
						Defense._armor_damage_reduction()
					1:
						Defense._skill_slot_add()
					2:
						Defense._skill_cooldown_reduction()
					3:
						Defense._skill_cooldown_reduction()

				counters[index] += 1
				letters[index] = char(letters[index].unicode_at(0) + 1)
				target_names[index] = base_names[index] + letters[index]
				break
	else:
		print("Max Level")
