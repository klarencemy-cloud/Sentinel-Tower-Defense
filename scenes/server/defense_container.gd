extends Control

signal refresh_pts

@onready var defense_1: TextureButton = $Defense1
@onready var defense_2: TextureButton = $Defense2
@onready var defense_3: TextureButton = $Defense3
@onready var defense_4: TextureButton = $Defense4
@onready var skill_cost: Label = $Defense2/Cost
@onready var sentinel_cost: Label = $Defense4/Cost
@onready var armor_cost: Label = $Defense1/Cost
@onready var skill_cd_cost: Label = $Defense3/Cost

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

var armor_real_cost: int = 1  #price
var skill_cd_real_cost: int = 1 #price

var armor_max_level: int = 0
var skill_cd_max_level: int = 0 

var skill_slot_price: int = 2 #price
var price_increment1: int = 2

var sentinel_slot_price: int = 2 #price
var price_increment2: int = 4

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
	
func _on_defense_upgrade_1_pressed() -> void: # Armor
	_upgrade(0)


func _on_defense_upgrade_2_pressed() -> void: # Skill Slot
	_upgrade(1)


func _on_defense_upgrade_3_pressed() -> void: # Skill CD
	_upgrade(2)


func _on_defense_upgrade_4_pressed() -> void: # Sentinel Deployed
	_upgrade(3)


func _upgrade(index: int) -> void:
	var counter = counters[index]
	var count = counts[index]
	
	if counter < count:
		match index:
			0:
				if Data.server_points < armor_real_cost:
					return
				Data.server_points -= armor_real_cost
				Defense._armor_damage_reduction()
				_armor_max_level()
			1:
				if Data.server_points < skill_slot_price:
					return
				Data.server_points -= skill_slot_price
				Defense._skill_slot_add()
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
				Defense._skill_cooldown_reduction()
				_sentinel_slot_increment()

		refresh_pts.emit()
		for child in children[index]:
			if child.name == target_names[index]:
				child.texture = load("res://graphics/upgrade/Upgraded.png")
				counters[index] += 1
				letters[index] = char(letters[index].unicode_at(0) + 1)
				target_names[index] = base_names[index] + letters[index]
				break
	else:
		print("Max Level")


func _armor_max_level() -> void:
	armor_max_level += 1
	if armor_max_level == defense1_count:
		armor_cost.text = "Max"


func _skill_cd_max_level() -> void:
	skill_cd_max_level += 1
	if skill_cd_max_level == defense3_count:
		skill_cd_cost.text = "Max"


func _skill_price_increment() -> void:
	skill_slot_price += price_increment1
	skill_cost.text = ("Cost: " + str(skill_slot_price))

	if skill_slot_price == 8:
		skill_cost.text = ("Max")


func _sentinel_slot_increment() -> void:
	sentinel_slot_price += price_increment2
	sentinel_cost.text = ("Cost: " + str(sentinel_slot_price))

	if sentinel_slot_price == 14:
		sentinel_cost.text = ("Max")
