extends CharacterBody2D

@export var speed = 100
var parent : Node2D

func _ready() -> void:
	parent = get_parent()

func _physics_process(delta: float) -> void:
	if parent:
		var direction = global_position.direction_to(parent.seeking.position)
		velocity = direction * speed
		move_and_slide()
