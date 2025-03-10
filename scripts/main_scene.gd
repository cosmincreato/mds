extends Node

@onready var spawn_manager: Node2D = $SpawnManager
@onready var timer: Timer = $Timer
@onready var base: Node2D = $Base
var enemy_scene = preload("res://scenes/enemy.tscn")


func _on_timer_timeout() -> void:
	var spawn_points = spawn_manager.get_children()
	var spawn_point = spawn_points.pick_random()
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn_point.position
	enemy.seeking = base
	add_child(enemy)
	
