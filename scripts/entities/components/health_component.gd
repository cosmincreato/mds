class_name HealthComponent extends Node

signal damage_taken(new_health : int, amount : int)
signal healed(new_health : int, amount : int)
signal died()

@export var max_health : int
@export var health : int

func _ready() -> void:
	health = max_health

### Public

func take_damage(amount : int) -> void:
	health -= amount
	
	if health <= 0:
		health = 0
		emit_signal("died")
	
	emit_signal("damage_taken", health, amount)
		
func heal(amount : int) -> void:
	health += amount
	
	if health > max_health:
		health = max_health

	emit_signal("healed", health, amount)
	
