extends Area2D

var is_exit := false
var exit_progress: float = 0.0

func _ready():
	# Only the entrance portal handles teleporting and lifetime.
	if !is_exit:
		body_entered.connect(_on_body_entered)
		area_entered.connect(_on_area_entered)

		await get_tree().create_timer(15.0).timeout

		if is_instance_valid(self):
			queue_free()

func _on_area_entered(area):
	if is_exit:
		return

	if !area.is_in_group("Enemies"):
		return

	if area.has_method("get") and area.get("path_follow") != null:
		area.path_follow.progress = exit_progress

func _on_body_entered(body):
	if is_exit:
		return

	if !body.is_in_group("Enemies"):
		return

	if body.has_method("get") and body.get("path_follow") != null:
		body.path_follow.progress = exit_progress
