extends Node

signal gold_changed(gold, amount)

var gold : int = 500
var allies : Array = []

func add_gold(amount: int) -> void:
	gold += amount
	gold_changed.emit(gold, amount)

func spend_gold(amount: int) -> void:
	if gold >= amount:
		gold -= amount
		gold_changed.emit(gold, amount)

func add_ally(ally : Node2D) -> void:
	allies.push_back(ally)
	
