class_name HealthBar extends ProgressBar

func update(new_health : int) -> void:
	value = new_health
	visible = (value != max_value)
