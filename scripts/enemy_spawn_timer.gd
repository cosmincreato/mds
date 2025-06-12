extends Timer

func _ready() -> void:
	await get_tree().physics_frame
	wait_time = 30

func _on_button_pressed() -> void:
	emit_signal("timeout")
