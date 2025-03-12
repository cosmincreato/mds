extends Node2D

func _ready() -> void:
	
	var health_bar: Node = $HealthBar
	health_bar.health_changed.connect(_on_health_changed)
	
func _on_health_changed(health : int) -> void:
	print(health)
	if health <= 0:
		#queue_free()
		pass
