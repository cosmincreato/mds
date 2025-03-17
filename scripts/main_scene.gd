extends Node

@onready var spawn_manager: Node2D = $SpawnManager
@onready var timer: Timer = $Timer
@onready var base: Node2D = $Base
@onready var canvas: Node2D = $Canvas

var enemy_scene = preload("res://scenes/enemies/enemy.tscn")
var allies_dir = DirAccess.open("res://scenes/allies/")

var allies_dictionary: Dictionary = {}
var hovering: bool = false

func _ready() -> void:
	for child in get_children():
		if child.has_method("set_dependencies"):
			child.set_dependencies(self)
	
	# Cream un dictionar in care retinem toate locatiile din fisiere
	# a scenelor pentru aliati
	var index = 1
	var path: String
	for allie in allies_dir.get_files():
		path = "res://scenes/allies/" + str(allie)
		allies_dictionary[index] = load(path)
		index += 1
		
	canvas.allie_spawned.connect(_on_allie_spawn)
	base.find_child("Hurtbox").mouse_entered.connect(_on_mouse_entered)
	base.find_child("Hurtbox").mouse_exited.connect(_on_mouse_exited)
	
func _input(event: InputEvent) -> void:
	#TODO verificare pentru fiecare tip de aliat nu doar pentru cel cu cheia 1
	if event.is_action_pressed("1") and !canvas.is_selected:
		var allie_scene = allies_dictionary[1]
		var allie = allie_scene.instantiate()
		var character_body = allie.get_child(0)
		var sprite = character_body.get_child(0)
		canvas._on_draw_sprite(sprite.texture)
	elif event.is_action_pressed("1") and canvas.is_selected:
		canvas._on_remove_sprite()

# Pozitionam trupa aliata pe harta doar in cazul in care aceasta
# nu da overlap cu un obiect deja existent
func _on_allie_spawn(mouse_x, mouse_y, type) -> void:
	if !hovering:
		var allie = allies_dictionary[type].instantiate()
		allie.position = Vector2(mouse_x, mouse_y)
		allie.find_child("Hurtbox").mouse_entered.connect(_on_mouse_entered)
		allie.find_child("Hurtbox").mouse_exited.connect(_on_mouse_exited)
		add_child(allie)

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
