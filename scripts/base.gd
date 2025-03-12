extends Node2D


func _on_health_bar_damage_taken(_new_health: int, amount: int) -> void:
	print(name + " has taken " + str(amount) + " damage.")
