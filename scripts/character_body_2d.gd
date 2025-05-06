extends CharacterBody2D

@export var speed : int = 300

var parent : Node2D = null
var moving : bool = false
var target_position : Vector2 = Vector2.ZERO

# Ii vom da nodului toate proprietatile de care are nevoie
func set_dependencies(p: Node2D):
	self.parent = p

func _physics_process(delta: float) -> void:
	if moving:
		var dir = global_position.direction_to(target_position)
		var dist = global_position.distance_to(target_position)
		
		if dist > 1: 
			velocity = dir * speed
			move_and_slide()
		else:
			velocity = Vector2.ZERO
			moving = false
			
func set_target_position(pos : Vector2) -> void:
	target_position = pos
	moving = true
	
