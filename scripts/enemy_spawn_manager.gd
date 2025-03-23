class_name EnemySpawnManager extends Node2D

signal enemy_spawned(enemy)

@onready var enemy_factory : EnemyFactory = get_node_or_null("EnemyFactory")

# Cand EnemySpawnTimer semnaleaza ca timerul a ajuns la 0, inamicul tb spawnat
func _on_enemy_spawn_timer_timeout() -> void:
	var spawn_points = get_node_or_null("SpawnPoints").get_children()
	var spawn_point = spawn_points.pick_random()
	# TODO aici se vor spawna in functie de mmai multi factori (wave, pattern etc)
	var enemy_type = enemy_factory.enemies.keys().pick_random()
	#
	var enemy = enemy_factory.create_enemy(enemy_type, spawn_point.position)
	enemy_spawned.emit(enemy)
