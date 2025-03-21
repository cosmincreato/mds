extends CharacterBody2D

var parent : Node2D = null
@export var speed : int = 300
		
func _physics_process(_delta: float) -> void:
	if parent.seeking:
		var dir = global_position.direction_to(parent.seeking.global_position)
		velocity = dir * speed
		move_and_slide()


# Ii vom da nodului toate proprietatile de care are nevoie
func set_dependencies(p: Node2D):
	self.parent = p
	
