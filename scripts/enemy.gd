extends Node2D

# Nodul catre care se va deplasa inamicul
@export var seeking : Node2D = null
var speed : int = 300

func _ready() -> void:
	# Dependency Injection pentru copiii care au nevoie de variabile din parinte
	for child in get_children():
		if child.has_method("set_dependencies"):
			child.set_dependencies(self)


func _on_health_bar_damage_taken(_new_health: int, amount: int) -> void:
	print(name + " has taken " + str(amount) + " damage.")


func _on_health_bar_died() -> void:
	queue_free()
