extends Node

signal health_changed(health)

@export var max_health: int = 1000
var health: int

func _ready() -> void:
	health = max_health

# Poate functiona drept damage sau heal
func set_health(amount: int) -> void:
	health = amount
	emit_signal("health_changed", health)
