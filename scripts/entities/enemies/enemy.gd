class_name Enemy extends Node2D

# Nodul catre care se va deplasa inamicul
@export var seeking : Node2D = null
@export var attacking : Node2D = null
@onready var health_bar : HealthBar = $CharacterBody2D/HealthBar
@onready var cooldown : Timer = $Cooldown
@onready var health_component : HealthComponent = get_node_or_null("HealthComponent")
@onready var animated_sprite_2d : AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D

var base : Node2D = null

func _ready() -> void:
	# Dependency Injection pentru copiii care au nevoie de variabile din parinte
	for child in get_children():
		if child.has_method("set_dependencies"):
			child.set_dependencies(self)
			
	health_component.damage_taken.connect(_on_health_component_damage_taken)
	health_component.died.connect(_on_health_component_died)
	animated_sprite_2d.play()

			
func _process(delta : float):
	if health_component.health <= 0:
		return
		
	if cooldown.time_left == 0 && attacking != null:
		var target_health_component = attacking.get_node_or_null("HealthComponent")
		
		if target_health_component:
			$AttackComponent.deal_damage(target_health_component)
			
		cooldown.start()

# Cand HealthComponent semnaleaza ca inamicul ca si-a luat damage
func _on_health_component_damage_taken(new_health: int, _amount: int) -> void:
	if health_bar:
		health_bar.update(new_health)

# Cand HealthComponent semnaleaza ca inamicul a fost ucis
func _on_health_component_died() -> void:
	GameManager.add_gold(50)
	queue_free()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.get_parent().is_in_group("allies"):
		attacking = body.get_parent()

func _on_attack_area_body_entered(body: Node2D) -> void:
	if (body.get_parent().is_in_group("allies")):
		seeking = body

func _on_attack_area_body_exited(body: Node2D) -> void:
	if (body.get_parent().is_in_group("allies")):
		print(base)
		seeking = base
