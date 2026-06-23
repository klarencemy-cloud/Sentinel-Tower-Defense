@tool
extends Control

@onready var economy_1: TextureButton = $Economy1
@onready var economy_2: TextureButton = $Economy2
@onready var economy_3: TextureButton = $Economy3

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
				counters[index] += 1
				letters[index] = char(letters[index].unicode_at(0) + 1) # Increment letter a to b and so on
				target_names[index] = base_names[index] + letters[index] # Combine base name and incremented letter "Upgrade1a" to "Upgrade1b"
				break
	else:
		print("Max Level")



