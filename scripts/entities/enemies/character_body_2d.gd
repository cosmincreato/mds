extends CharacterBody2D

var parent : Node2D = null
@export var speed : int = 300
@onready var naviagtion_agent_2d : NavigationAgent2D = $NavigationAgent2D
		
func _physics_process(_delta: float) -> void:
	if naviagtion_agent_2d.is_navigation_finished():
		return
		
	var next_path =  naviagtion_agent_2d.get_next_path_position()
	velocity = global_position.direction_to(next_path) * speed
	move_and_slide()

# Ii vom da nodului toate proprietatile de care are nevoie
func set_dependencies(p: Node2D):
	self.parent = p
	
