extends Node

@onready var spawn_manager: Node2D = $EnemySpawnManager
@onready var base: Base = $Base
@onready var ally_spawn_canvas: AllySpawnCanvas = $AllySpawnCanvas
@onready var gold_count_label : GoldCountLabel = get_node_or_null("GoldCountLabel")

var allies_dir = DirAccess.open("res://scenes/entities/allies/")

var allies_dictionary: Dictionary = {}
var hovering: bool = false

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
	
	
func _input(event: InputEvent) -> void:
	#TODO verificare pentru fiecare tip de aliat nu doar pentru cel cu cheia 1
	if event.is_action_pressed("1") and !ally_spawn_canvas.visible:
		var ally_scene = allies_dictionary[1]
		var ally = ally_scene.instantiate()
		var sprite = ally.get_node_or_null("CharacterBody2D/Sprite2D")
		var cost_component = ally.get_node_or_null("CostComponent")
		ally_spawn_canvas.add_canvas_items(sprite.texture, cost_component.cost)
		ally.queue_free()
	elif event.is_action_pressed("1") and ally_spawn_canvas.visible:
		ally_spawn_canvas.remove_canvas_items()

# Cand AllySpawnCanvas semnaleaza ca incercam sa spawnam o unitate
func _on_canvas_ally_spawned(mouse_x: float, mouse_y: float, type: int) -> void:
	if !hovering:
		var ally = allies_dictionary[type].instantiate()
		ally.position = Vector2(mouse_x, mouse_y)
		ally.find_child("Hurtbox").mouse_entered.connect(_on_mouse_entered)
		ally.find_child("Hurtbox").mouse_exited.connect(_on_mouse_exited)
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
	
# Cand EnemySpawnManager semnaleaza ca un inamic s-a spawnat
func _on_enemy_spawn_manager_enemy_spawned(enemy: Enemy) -> void:
	enemy.seeking = base
	enemy.find_child("Hurtbox").mouse_entered.connect(_on_mouse_entered)
	enemy.find_child("Hurtbox").mouse_exited.connect(_on_mouse_exited)
	add_child(enemy)
	
func _on_mouse_entered() -> void:
	hovering = true
	
func _on_mouse_exited() -> void:
	hovering = false
