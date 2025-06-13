class_name AttackComponent extends Node

@export var attack_damage: int

func deal_damage(target : HealthComponent) -> void:
	target.take_damage(attack_damage)
	
