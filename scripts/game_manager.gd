extends Node

signal gold_changed(gold, amount)

var gold : int = 500

func add_gold(amount: int) -> void:
	gold += amount
	gold_changed.emit(gold, amount)

func spend_gold(amount: int) -> void:
	if gold >= amount:
		gold -= amount
		gold_changed.emit(gold, amount)
