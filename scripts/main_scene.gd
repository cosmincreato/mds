extends Node

@onready var spawn_manager: Node2D = $SpawnManager
@onready var timer: Timer = $Timer
@onready var base: Base = $Base
@onready var canvas: Canvas = $Canvas

var enemy_scene = preload("res://scenes/enemies/enemy.tscn")
var allies_dir = DirAccess.open("res://scenes/allies/")

var allies_dictionary: Dictionary = {}
var hovering: bool = false

func _ready() -> void:
	# Cream un dictionar in care retinem toate locatiile din fisiere
	# a scenelor pentru aliati
	var index = 1
	var path: String
	for ally in allies_dir.get_files():
		path = "res://scenes/allies/" + str(ally)
		allies_dictionary[index] = load(path)
		index += 1

	base.find_child("Hurtbox").mouse_entered.connect(_on_mouse_entered)
	base.find_child("Hurtbox").mouse_exited.connect(_on_mouse_exited)
	
	
func _input(event: InputEvent) -> void:
	#TODO verificare pentru fiecare tip de aliat nu doar pentru cel cu cheia 1
	if event.is_action_pressed("1") and !canvas.is_selected:
		var ally_scene = allies_dictionary[1]
		var ally = ally_scene.instantiate()
		var character_body = ally.get_node_or_null("CharacterBody2D")
		var sprite = character_body.get_node_or_null("Sprite2D")
		canvas.draw_sprite(sprite.texture)
	elif event.is_action_pressed("1") and canvas.is_selected:
		canvas.remove_sprite()

# Pozitionam trupa aliata pe harta doar in cazul in care aceasta
# nu da overlap cu un obiect deja existent
func _on_canvas_ally_spawned(mouse_x: float, mouse_y: float, type: int) -> void:
	if !hovering:
		var ally = allies_dictionary[type].instantiate()
		ally.position = Vector2(mouse_x, mouse_y)
		ally.find_child("Hurtbox").mouse_entered.connect(_on_mouse_entered)
		ally.find_child("Hurtbox").mouse_exited.connect(_on_mouse_exited)
		add_child(ally)

# Cream trupele inamice in momentul in care timerul atinge 0
func _on_timer_timeout() -> void:
	var spawn_points = spawn_manager.get_children()
	var spawn_point = spawn_points.pick_random()
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn_point.position
	enemy.seeking = base
	#BUG not connecting the signal properly
	enemy.find_child("Hurtbox").mouse_entered.connect(_on_mouse_entered)
	enemy.find_child("Hurtbox").mouse_exited.connect(_on_mouse_exited)
	add_child(enemy)
	
func _on_mouse_entered() -> void:
	print("entered")
	hovering = true
	
func _on_mouse_exited() -> void:
	print("exited")
	hovering = false
