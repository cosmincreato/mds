class_name Base extends Node2D

signal died();

@onready var health_component : HealthComponent = get_node_or_null("HealthComponent")
@onready var health_bar : HealthBar = get_node_or_null("HealthBar")
@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if health_bar:
		health_bar.max_value = health_component.max_health
	animated_sprite_2d.play()
		

# Cand Hurtbox semnaleaza ca cineva a intrat in coliziune cu baza
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.get_parent().is_in_group("enemies"):
		var enemy_health_component = body.get_parent().get_node_or_null("HealthComponent")
		var enemy_attack_component = body.get_parent().get_node_or_null("AttackComponent")
		
		if enemy_attack_component:
			enemy_attack_component.deal_damage(health_component)
			
		enemy_health_component.take_damage(enemy_health_component.health)

# Cand HealthComponent semnaleaza ca baza ca si-a luat damage
func _on_health_component_damage_taken(new_health: int, amount: int) -> void:
	if health_bar:
		health_bar.update(new_health)
#
## Cand HealthComponent semnaleaza ca baza a fost distrusa
func _on_health_component_died() -> void:
	died.emit();
