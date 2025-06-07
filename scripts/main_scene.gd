extends Node


@onready var spawn_manager: Node2D = $EnemySpawnManager
@onready var base: Base = $Base
@onready var ally_spawn_canvas: AllySpawnCanvas = $AllySpawnCanvas
@onready var gold_count_label: GoldCountLabel = get_node_or_null("GoldCountLabel")

@export var main_menu_path := "res://scenes/main_menu.tscn"

var enemies_dir = DirAccess.open("res://scenes/entities/enemies")
var allies_dir = DirAccess.open("res://scenes/entities/allies/")
var current_ally_type = 1  # Tipul curent de ally (1 = Ally, 2 = Tower)

var pause_menu_instance : Node
var enemies := []
var allies_dictionary : Dictionary = {}
var hovering : bool = false
var ally_hovering : bool = false
var hovered_ally : Node2D = null
var selected_allies : Array = []

func _ready() -> void:
	# Cream un dictionar in care retinem toate locatiile din fisiere
	# a scenelor pentru aliati
	var index = 1
	var path: String
	for ally in allies_dir.get_files():
		path = allies_dir.get_current_dir() + "/" + str(ally)
		allies_dictionary[index] = load(path)
		index += 1

	base.find_child("Hurtbox").mouse_entered.connect(_on_mouse_entered)
	base.find_child("Hurtbox").mouse_exited.connect(_on_mouse_exited)
	base.find_child("Hurtbox").collision_layer = 1 << 0
	base.find_child("Hurtbox").collision_mask = 1 << 1
	
	for enemy in enemies_dir.get_files():
		path = enemies_dir.get_current_dir() + "/" + str(enemy)
		enemies.append(load(path))

func _input(event: InputEvent) -> void:
	#TODO verificare pentru fiecare tip de aliat nu doar pentru cel cu cheia 1
	if event.is_action_pressed("1"):
		current_ally_type = 1
		#var ally_scene = allies_dictionary[1]
		#var ally = ally_scene.instantiate()
		#var sprite = ally.get_node_or_null("CharacterBody2D/Sprite2D")
		#var cost_component = ally.get_node_or_null("CostComponent")
		#ally_spawn_canvas.add_canvas_items(sprite.texture, cost_component.cost)
		#ally.queue_free()
	elif event.is_action_pressed("2"):
		current_ally_type = 2
	else:
		return
		
	if !ally_spawn_canvas.visible:
		var ally_scene = allies_dictionary[current_ally_type]
		var ally = ally_scene.instantiate()
		var sprite = ally.get_node_or_null("CharacterBody2D/Sprite2D")
		var cost_component = ally.get_node_or_null("CostComponent")
		if sprite and cost_component:
			ally_spawn_canvas.add_canvas_items(sprite.texture, cost_component.cost)
		ally.queue_free()
	else:
		ally_spawn_canvas.remove_canvas_items()

	if event.is_action_pressed("left_mouse") && ally_hovering:
		selected_allies.push_back(hovered_ally)
	if event.is_action_pressed("right_mouse") && selected_allies.size() != 0:
		var move_to = get_viewport().get_camera_2d().get_global_mouse_position()
		for ally in selected_allies:
			var body = ally.get_node_or_null("CharacterBody2D")
			if body:
				body.set_target_position(move_to)
	if event.is_action("left_mouse") && !ally_hovering:
		selected_allies = []
	
				
# Cand AllySpawnCanvas semnaleaza ca incercam sa spawnam o unitate
func _on_canvas_ally_spawned(mouse_x: float, mouse_y: float) -> void:
	print("Test")
	if !hovering:
		var ally = allies_dictionary[current_ally_type].instantiate()
		ally.position = Vector2(mouse_x, mouse_y)
		var ally_hurtbox = ally.find_child("Hurtbox")
		ally_hurtbox.mouse_entered.connect(_on_mouse_entered)
		ally_hurtbox.mouse_entered.connect(_on_ally_mouse_entered.bind(ally))
		ally_hurtbox.mouse_exited.connect(_on_mouse_exited)
		ally_hurtbox.mouse_exited.connect(_on_ally_mouse_exited)
		var ally_collision_shape = ally.find_child("CharacterBody2D")
		if ally_collision_shape:
			ally_collision_shape.collision_layer = 1 << 0
			ally_collision_shape.collision_mask = 1 << 1
		buy_ally(ally)
	else:
		print("Invalid position")

func can_afford_ally(ally : Node2D) -> bool:
	var cost_component = ally.get_node_or_null("CostComponent")
	if cost_component:
		return GameManager.gold >= cost_component.cost
	return true
	
func buy_ally(ally : Node2D) -> void:
	if can_afford_ally(ally):
		var cost_component = ally.get_node_or_null("CostComponent")
		if cost_component:
			GameManager.spend_gold(cost_component.cost)
			add_child(ally)
	else:
		print("Not enough gold")
	ally_spawn_canvas.remove_canvas_items()

# Cream trupele inamice in momentul in care timerul atinge 0
func _on_enemy_spawn_timer_timeout() -> void:
	var spawn_points = spawn_manager.get_children()
	var spawn_point = spawn_points.pick_random()
	# TODO aici o sa avem un algoritm de spawnat bazat pe wave,
	#eu doar am pus random ca sa vad ca merge sa spawnam tipuri de inamici
	var enemy = enemies.pick_random().instantiate()
	enemy.position = spawn_point.position
	enemy.seeking = base
	enemy.base = base
	enemy.find_child("Hurtbox").mouse_entered.connect(_on_mouse_entered)
	enemy.find_child("Hurtbox").mouse_exited.connect(_on_mouse_exited)
	enemy.find_child("CharacterBody2D").collision_layer = 1 << 1
	enemy.find_child("CharacterBody2D").collision_mask = 1 << 0
	add_child(enemy)

func _on_mouse_entered() -> void:
	hovering = true
	
func _on_mouse_exited() -> void:
	hovering = false
	
func _on_ally_mouse_entered(ally : Node2D) -> void:
	ally_hovering = true
	hovered_ally = ally
	
func _on_ally_mouse_exited() -> void:
	ally_hovering = false
	hovered_ally = null
	
func remove_from_selected(ally: Node2D) -> void:
	selected_allies.erase(ally)

func _on_ExitButton_pressed():
	var main_menu = load(main_menu_path).instantiate()
	get_tree().root.add_child(main_menu)
	
	queue_free()
