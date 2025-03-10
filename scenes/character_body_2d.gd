extends CharacterBody2D

var seeking : Node2D = null
var speed : int = 100

func _ready() -> void:
	if seeking:
		print(seeking.name)
		
func _physics_process(_delta: float) -> void:
	var dir = global_position.direction_to(seeking.global_position)
	velocity = dir * speed
	move_and_slide()

func set_seeking(target : Node2D) -> void:
	seeking = target
	
func set_speed(value : int) -> void:
	speed = value
