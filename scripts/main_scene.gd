class_name MainScene extends Node


# Variabile copil care trebuie luate atunci cand intreg tree-ul
# este gata de executie
@onready var spawn_manager: Node2D = get_node_or_null("EnemySpawn/EnemySpawnManager")
@onready var base: Base = get_node_or_null("Base")
@onready var ally_spawn_canvas: AllySpawnCanvas = get_node_or_null("AllySpawnCanvas")
@onready var gold_count_label: GoldCountLabel = get_node_or_null("GoldCountLabel")

# Constanta pentru durata indicatorului de spawnat inamici
const ALERT_TIMER_SPEED = 3

var pause_menu_scene := "res://scenes/pause_menu.tscn"

# Directoarele pentru entitati
var enemies_dir = DirAccess.open("res://scenes/entities/enemies")
var allies_dir = DirAccess.open("res://scenes/entities/allies/")

# Tipul curent de ally (1 = Ally, 2 = Tower)
var current_ally_type = null

# Dictionar cu aliati pentru accesare rapida la instantieri
var allies_dictionary : Dictionary = {}

# Variabile ajutatoare pentru instantierea aliatilor
var hovering : bool = false
var ally_hovering : bool = false
var placing_ally : bool = false

# Variabile pentru mutarea aliatilor pe harta
var hovered_ally : Node2D = null
var selected_allies : Array = []

# Factory pentru instantierea inamicilor
var enemy_factory : EnemyFactory = EnemyFactory.new()

# Variabile pentru logica spawnarii inamicilor
var time = 0
var wave_count = 1

func _ready() -> void:
	# Cream un dictionar in care retinem toate locatiile din fisiere
	# a scenelor pentru aliati
	var index = 1
	var path: String
	for ally in allies_dir.get_files():
		path = allies_dir.get_current_dir() + "/" + str(ally)
		allies_dictionary[index] = load(path)
		index += 1
	
	# Conectam semnalele copiilor catre scena principala
	base.died.connect(_on_base_died)
	base.find_child("Hurtbox").mouse_entered.connect(_on_mouse_entered)
	base.find_child("Hurtbox").mouse_exited.connect(_on_mouse_exited)
		

# Setarea variabilelor daca player-ul apasa tastele 1 sau 2 de spawnat
func place_ally(index : int) -> void:
	if placing_ally:
		placing_ally = false
		current_ally_type = null
	else:
		placing_ally = true
		current_ally_type = index

func _input(event: InputEvent) -> void:
	for index in range(1, 2):
		if event.is_action_pressed(str(index)):
			place_ally(index)
		
	if !ally_spawn_canvas.visible and placing_ally:
		var ally_scene = allies_dictionary[current_ally_type]
		var ally = ally_scene.instantiate()
		
		var sprite_node = ally.get_node_or_null("CharacterBody2D/AnimatedSprite2D")

		if sprite_node == null:
			sprite_node = ally.get_node_or_null("CharacterBody2D/Sprite2D")

		var sprite_frame : Texture2D = null

		if sprite_node is AnimatedSprite2D:
			var frames = sprite_node.sprite_frames
			if frames != null and frames.has_animation("default"):
				sprite_frame = frames.get_frame_texture("default", 0)
		elif sprite_node is Sprite2D:
			sprite_frame = sprite_node.texture

		var cost_component = ally.get_node_or_null("CostComponent")

		if sprite_frame and cost_component:
			ally_spawn_canvas.add_canvas_items(sprite_frame, cost_component.cost)
		ally.queue_free()
	elif placing_ally == false:
		ally_spawn_canvas.remove_canvas_items()

	if event.is_action_pressed("left_mouse") and ally_hovering and hovered_ally.is_in_group("moveable"):
		selected_allies.push_back(hovered_ally)
	if event.is_action_pressed("right_mouse") && selected_allies.size() != 0:
		var move_to = get_viewport().get_camera_2d().get_global_mouse_position()
		for ally in selected_allies:
			var body = ally.get_node_or_null("CharacterBody2D")
			if body:
				body.set_target_position(move_to)
		selected_allies = []
				
	if event.is_action("left_mouse") && !ally_hovering:
		selected_allies = []
	
				
# Cand AllySpawnCanvas semnaleaza ca incercam sa spawnam o unitate
func _on_canvas_ally_spawned(mouse_x: float, mouse_y: float) -> void:
	if !hovering:
		var ally = allies_dictionary[current_ally_type].instantiate()
		ally.position = Vector2(mouse_x, mouse_y)
		
		# Flip pe partea stanga
		if ally.position.x < 353:
			var cb = ally.get_node_or_null("CharacterBody2D")
			if  cb.has_node("Sprite2D"):
				cb.get_node("Sprite2D").flip_h = true
			elif cb.has_node("AnimatedSprite2D"):
				cb.get_node("AnimatedSprite2D").flip_h = true
			
		
		var ally_hurtbox = ally.find_child("Hurtbox")
		ally_hurtbox.mouse_entered.connect(_on_mouse_entered)
		ally_hurtbox.mouse_entered.connect(_on_ally_mouse_entered.bind(ally))
		ally_hurtbox.mouse_exited.connect(_on_mouse_exited)
		ally_hurtbox.mouse_exited.connect(_on_ally_mouse_exited)
		buy_ally(ally)
	else:
		print("Invalid position")

# Verificare daca player-ul poate cumpara o unitate
func can_afford_ally(ally : Node2D) -> bool:
	var cost_component = ally.get_node_or_null("CostComponent")
	if cost_component:
		return GameManager.gold >= cost_component.cost
	return true
	
# Player-ul cumpara o unitate
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
	for i in range(0, wave_count):
		var spawn_points = spawn_manager.get_children()
		var spawn_point = spawn_points.pick_random()
		var spawn_point_id : String = str(spawn_point.name).replace("SpawnPoint","")
		print(spawn_point_id)
		var spawn_alert : TextureRect = get_node_or_null("EnemySpawn/EnemySpawnCanvas/EnemyAlert" + spawn_point_id)
		if spawn_alert:
			# Cream un timer special pentru alerta
			spawn_alert.visible = true
			await get_tree().create_timer(ALERT_TIMER_SPEED).timeout
			spawn_alert.visible = false
		var enemy_type
		if wave_count < 3:
			enemy_type = "Skeleton"
		elif wave_count % 10 == 0 and wave_count != 0:
			enemy_type = "Boss"
			instantiate_enemy(enemy_type, spawn_point)
			wave_count = wave_count + 1
			break
		else:
			enemy_type = enemy_factory.enemies.keys().filter(func(k): return k != "Boss").pick_random()
		
		var enemy = enemy_factory.create_enemy(enemy_type, spawn_point.position)
		instantiate_enemy(enemy_type, spawn_point)
	wave_count = wave_count + 1
	

# Daca player-ul da hover peste o unitate deja existenta, semnalam
func _on_mouse_entered() -> void:
	hovering = true
	
	
func _on_mouse_exited() -> void:
	hovering = false
	
	
# Daca player-ul player-ul da hover peste un aliat deja existent pentru a-l muta, semnalam
func _on_ally_mouse_entered(ally : Node2D) -> void:
	ally_hovering = true
	hovered_ally = ally
	
	
func _on_ally_mouse_exited() -> void:
	ally_hovering = false
	hovered_ally = null
	
	
func remove_from_selected(ally: Node2D) -> void:
	selected_allies.erase(ally)


func _on_PauseButton_pressed():
	var pause_menu : Node = load(pause_menu_scene).instantiate()
	get_tree().root.add_child(pause_menu)

	get_tree().paused = true


# Crestem timpul din joc
func _on_timer_timeout() -> void:
	time = time + 1


# Cand dam skip la wave
func _on_button_pressed() -> void:
	GameManager.add_gold(100)
	
	
# Cand baza moare si jocul se termina
func _on_base_died() -> void:
	var main_menu = load("res://scenes/main_menu.tscn").instantiate()
	get_tree().root.add_child(main_menu)
	queue_free()


# Instantiem inamici folosind factory
func instantiate_enemy(enemy_type, spawn_point) -> void:
	var enemy = enemy_factory.create_enemy(enemy_type, spawn_point.position)
	enemy.seeking = base
	enemy.base = base
	enemy.find_child("Hurtbox").mouse_entered.connect(_on_mouse_entered)
	enemy.find_child("Hurtbox").mouse_exited.connect(_on_mouse_exited)
	add_child(enemy)
	await get_tree().physics_frame
	enemy.navigation_agent_2d.target_position = enemy.seeking.global_position
