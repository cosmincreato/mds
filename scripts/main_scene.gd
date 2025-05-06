extends Node

@onready var spawn_manager: Node2D = $EnemySpawnManager
@onready var base: Base = $Base
@onready var ally_spawn_canvas: AllySpawnCanvas = $AllySpawnCanvas
@onready var gold_count_label : GoldCountLabel = get_node_or_null("GoldCountLabel")

var allies_dir = DirAccess.open("res://scenes/entities/allies/")

var allies_dictionary: Dictionary = {}
var hovering: bool = false

var current_ally_type = 1

func _ready() -> void:
	print("Director analizat: " + allies_dir.get_current_dir())

	var index = 1
	allies_dir.list_dir_begin()
	var file_name := allies_dir.get_next()

	while file_name != "":
		if file_name.ends_with(".tscn"):
			var path = allies_dir.get_current_dir() + "/" + file_name
			var scene = load(path)
			
			if scene:
				print("Index $index:")
				print(" - Fisier: $file_name")
				print(" - Cale: $path")
				print(" - Scena hash: " + str(scene.get_instance_id()))
				
				allies_dictionary[index] = scene
				print("Loaded ally type " + str(index) + ": " + file_name)
				index += 1
			else:
				print("EROARE: Nu s-a putut încărca scena: " + path)
		file_name = allies_dir.get_next()
	allies_dir.list_dir_end()

	base.find_child("Hurtbox").mouse_entered.connect(_on_mouse_entered)
	base.find_child("Hurtbox").mouse_exited.connect(_on_mouse_exited)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") and ally_spawn_canvas.visible:
		_on_canvas_ally_spawned(ally_spawn_canvas.mouse_x, ally_spawn_canvas.mouse_y, current_ally_type)
		return
	
	if event.is_action_pressed("1"):
		current_ally_type = 1 #debug
	elif event.is_action_pressed("2"):
		current_ally_type = 2
	else:
		return
	
	print("current_ally_type:", current_ally_type, " | Tip:", typeof(current_ally_type))
	
	#debug
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

# Cand AllySpawnCanvas semnaleaza ca incercam sa spawnam o unitate
func _on_canvas_ally_spawned(mouse_x: float, mouse_y: float, type: int) -> void:
	if !hovering:
		if !allies_dictionary.has(type):
			print("EROARE: Nu există ally de tipul:", type)
			return

		var ally = allies_dictionary[type].instantiate()
		ally.position = Vector2(mouse_x, mouse_y)
		
		# Debug inițial
		print("Spawnez entitate de tip: " + str(type))
		print(" - Nod root inițial: " + ally.name)
		
		add_child(ally)
		
		#Debug dupa adaugare:
		print(" - Nod root după adăugare: " + ally.name)
		# Debug: verificăm ce tip de nod avem
		#print("Spawnez entitate de tip: " + str(type))
		#print(" - Nod root: " + ally.name)
		#var sprite = ally.get_node_or_null("CharacterBody2D/Sprite2D")
		#if sprite and sprite.texture:
			#print(" - Textura: " + sprite.texture.get_path())
		#else:
			#print(" - Textura: lipsă sau invalidă")
		# Conectăm evenimentele dacă au un nod "Hurtbox"
		var hurtbox = ally.get_node_or_null("Hurtbox")
		if hurtbox:
			hurtbox.mouse_entered.connect(_on_mouse_entered)
			hurtbox.mouse_exited.connect(_on_mouse_exited)
		# Adăugăm efectiv pe scenă
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

		# Debug: Verificăm numele nodului rădăcină
		print("Nume nod root în buy_ally: " + ally.name)

		add_child(ally)
	else:
		print("Not enough gold")
		ally.queue_free()

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
