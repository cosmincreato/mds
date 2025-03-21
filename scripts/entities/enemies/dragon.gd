class_name Dragon extends Enemy

func _ready() -> void:
	super()
	print("Dragon spawned")
	
func _on_health_component_damage_taken(new_health: int, _amount: int) -> void:
	health_bar.update(new_health)

func _on_health_component_died() -> void:
	queue_free()
