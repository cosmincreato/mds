class_name Elf extends Node2D

@onready var health_component : HealthComponent = get_node_or_null("HealthComponent")
@onready var health_bar : HealthBar = $CharacterBody2D/HealthBar
@onready var cooldown : Timer = $Cooldown
@onready var animated_sprite_2d : AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D
@onready var attack_component : AttackComponent = get_node_or_null("AttackComponent")

var attacking : Node2D = null

func _ready() -> void:
	if health_bar:
		health_bar.max_value = health_component.max_health
	animated_sprite_2d.play()
	

func _process(delta) -> void :
	if health_component.health <= 0:
		return
	
	if cooldown.time_left == 0 && attacking != null:
		var target_health_component : HealthComponent = attacking.get_node_or_null("HealthComponent")
		
		if target_health_component:
			attack_component.deal_damage(target_health_component)
		cooldown.start()

func _on_health_component_died() -> void:
	if is_instance_valid(get_parent()):
		get_parent().remove_from_selected(self)
	queue_free()

func _on_health_component_damage_taken(new_health: int, amount: int) -> void:
	if health_bar:
		health_bar.update(new_health)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.get_parent().is_in_group("enemies"):
		attacking = body.get_parent()
