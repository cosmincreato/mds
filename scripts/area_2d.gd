extends Area2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	var enemy_health = body.get_parent().get_node("HealthBar")
	var base_health = get_parent().get_node("HealthBar")
	##
	enemy_health.set_health(0)
	base_health.set_health(base_health.health - 10)
