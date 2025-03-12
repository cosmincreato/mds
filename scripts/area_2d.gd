extends Area2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent().is_in_group("enemies"):
		var enemy_health = body.get_node("HealthBar")
		var enemy_attack = body.get_parent().get_node("Attack")
		var base_health = get_parent().get_node("HealthBar")
		##
		enemy_health.take_damage(enemy_health.health)
		base_health.take_damage(enemy_attack.attack)
