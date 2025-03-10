extends Node2D

# Nodul catre care se va deplasa inamicul
@export var seeking : Node2D = null
@export var speed = 100

func _ready() -> void:
	var body : CharacterBody2D = $CharacterBody2D
	body.set_seeking(seeking)
	body.set_speed(speed)
