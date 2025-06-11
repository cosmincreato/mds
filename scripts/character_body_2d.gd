extends CharacterBody2D

@export var speed : int = 150
@onready var naviagtion_agent_2d : NavigationAgent2D = $NavigationAgent2D

var parent : Node2D = null
var moving : bool = false
var target_position : Vector2 = Vector2.ZERO

# Ii vom da nodului toate proprietatile de care are nevoie
func set_dependencies(p: Node2D):
	self.parent = p
	
func _physics_process(delta: float) -> void:
	if naviagtion_agent_2d.is_navigation_finished():
		return
		
	var next_path =  naviagtion_agent_2d.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path) * speed
	
	if naviagtion_agent_2d.avoidance_enabled:
		naviagtion_agent_2d.set_velocity(new_velocity)
	else:
		velocity = new_velocity
	
	move_and_slide()

func set_target_position(pos : Vector2) -> void:
	target_position = pos
	naviagtion_agent_2d.target_position = pos
	


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
