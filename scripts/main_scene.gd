extends Node

signal draw_sprite(texture)
signal remove_sprite

@onready var spawn_manager: Node2D = $SpawnManager
@onready var timer: Timer = $Timer
@onready var base: Node2D = $Base

@onready var canvas: Node2D = find_child("Canvas")
var enemy_scene = preload("res://scenes/enemies/enemy.tscn")
var allies_dir = DirAccess.open("res://scenes/allies/")
var allies_dictionary: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child.has_method("set_dependencies"):
			child.set_dependencies(self)

	var index = 1
	var path: String
	for allie in allies_dir.get_files():
		path = "res://scenes/allies/" + str(allie)
		allies_dictionary[index] = load(path)
		index += 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1") and !canvas.is_selected:
		var allie_scene = allies_dictionary[1]
		var allie = allie_scene.instantiate()
		var character_body = allie.get_child(0)
		var sprite = character_body.get_child(0)
		draw_sprite.emit(sprite.texture)
	elif event.is_action_pressed("1") and canvas.is_selected:
		remove_sprite.emit()
	
func _on_timer_timeout() -> void:
	var spawn_points = spawn_manager.get_children()
	var spawn_point = spawn_points.pick_random()
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn_point.position
	enemy.seeking = base
	add_child(enemy)
	
