class_name EnemyFactory extends Node

@export var enemies : Dictionary[String, PackedScene] = {
	"Skeleton": preload("res://scenes/entities/enemies/skeleton.tscn"),
	"Dragon": preload("res://scenes/entities/enemies/dragon.tscn")
}

func create_enemy(type : String, position : Vector2) -> Enemy:	
	var enemy = enemies[type].instantiate()
	enemy.position = position
	return enemy
