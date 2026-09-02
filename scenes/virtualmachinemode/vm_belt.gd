extends Control

const SLOT_WIDTH := 179.0
const SLOT_HEIGHT := 244.0
const SLOT_GAP := 22.0
const SLOT_STEP := SLOT_WIDTH + SLOT_GAP
const SLOT_COUNT := 5
const SHIFT_DURATION := 2.5

var belt_card_scene := preload("res://scenes/virtualmachinemode/vm_belt_card.tscn")

var _ui_node
var _cards: Dictionary = {}


func setup(ui_node) -> void:
	_ui_node = ui_node

	anchor_top = 1.0
	anchor_bottom = 1.0
	offset_left = 40.0
	offset_top = -267.0
	offset_right = 1041.0
	offset_bottom = -25.0
	grow_vertical = 0
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	Data.vm_belt_changed.connect(_sync_visuals)
	_sync_visuals()


func _sync_visuals() -> void:
	var current_ids: Dictionary = {}
	for item in Data.vm_belt:
		current_ids[int(item["id"])] = true

	for id in _cards.keys().duplicate():
		if not current_ids.has(id):
			_cards[id].queue_free()
			_cards.erase(id)

	for i in range(Data.vm_belt.size()):
		var item: Dictionary = Data.vm_belt[i]
		var id: int = int(item["id"])
		var target_x: float = i * SLOT_STEP

		if not _cards.has(id):
			var card = belt_card_scene.instantiate()
			card.setup(item)
			card.position = Vector2(SLOT_COUNT * SLOT_STEP, 0)
			card.press.connect(_on_card_pressed)
			add_child(card)
			_cards[id] = card
			card.set_selected(Data.vm_belt_selected_id == id)

		var card = _cards[id]
		var tween := create_tween()
		tween.tween_property(card, "position:x", target_x, SHIFT_DURATION).set_trans(Tween.TRANS_LINEAR)


func _on_card_pressed(item_id: int) -> void:
	var item := _find_item(item_id)
	if item.is_empty():
		return

	Data.vm_belt_selected_id = item_id

	if item["kind"] == "tower":
		_ui_node.tower_select(int(item["type"]))
	else:
		_ui_node.sentinel_select(int(item["type"]))


func _find_item(item_id: int) -> Dictionary:
	for item in Data.vm_belt:
		if int(item["id"]) == item_id:
			return item
	return {}
