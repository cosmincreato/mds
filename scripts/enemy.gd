class_name Enemy extends Node2D

# Nodul catre care se va deplasa inamicul
@export var seeking : Node2D = null
@onready var health_bar : HealthBar = get_node_or_null("CharacterBody2D/HealthBar")

func _ready() -> void:
	# Dependency Injection pentru copiii care au nevoie de variabile din parinte
	for child in get_children():
		if child.has_method("set_dependencies"):
			child.set_dependencies(self)

# Cand HealthComponent semnaleaza ca inamicul ca si-a luat damage
func _on_health_component_damage_taken(new_health: int, _amount: int) -> void:
	health_bar.update(new_health)

# Cand HealthComponent semnaleaza ca inamicul a fost ucis
func _on_health_component_died() -> void:
	queue_free()
