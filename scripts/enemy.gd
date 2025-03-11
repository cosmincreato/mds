extends Node2D

# Nodul catre care se va deplasa inamicul
var seeking : Node2D = null
var speed : int = 300

func _ready() -> void:
	
	var healthBar : Node = $HealthBar
	
	# Dependency Injection pentru copiii care au nevoie de variabile din parinte
	for child in get_children():
		if child.has_method("set_dependencies"):
			child.set_dependencies(self)
			
	healthBar.health_changed.connect(_on_health_changed)
	
func _on_health_changed(health : int) -> void:
	if health <= 0:
		queue_free()
