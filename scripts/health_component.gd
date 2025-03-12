extends Control

signal damage_taken(new_health : int, amount : int)
signal healed(new_health : int, amount : int)
signal died()

@export var max_health: int = 1000
var health: int

func _ready() -> void:
	health = max_health
	
	# Dependency Injection pentru copiii care au nevoie de variabile din parinte
	for child in get_children():
		if child.has_method("set_dependencies"):
			child.set_dependencies(self)

# Poate functiona drept damage sau heal
func take_damage(amount : int):
	health -= amount
	
	if health <= 0:
		health = 0
		emit_signal("died")
	
	emit_signal("damage_taken", health, amount)
		
func heal(amount : int):
	health += amount
	
	if health > max_health:
		health = max_health
	
	emit_signal("healed", health, amount)
