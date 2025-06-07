class_name AttackComponent extends Node

@export var attack_damage: int

func deal_damage(target : HealthComponent) -> void:
	# aici putem avea pe viitor ceva calcule pt crit chance
	# sau alte chestii tari
	target.take_damage(attack_damage)
	
