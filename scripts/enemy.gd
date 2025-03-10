extends CharacterBody2D

const SPEED = 100
var parent : Node2D

func _ready() -> void:
	parent = get_parent()

func _physics_process(delta: float) -> void:
	if parent:
		var direction = position.direction_to(parent.seeking.position)
		velocity = direction * SPEED
		move_and_slide()
