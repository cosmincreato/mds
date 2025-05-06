class_name HealthBar extends ProgressBar

### Public

func update(new_health : int) -> void:
	value = new_health
	visible = (value != max_value)
 	
