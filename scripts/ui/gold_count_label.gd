class_name GoldCountLabel extends RichTextLabel

func _ready() -> void:
	GameManager.gold_changed.connect(update)

func update(gold : int, _amount : int) -> void:
	text = "[font_size='70'][b][color='yellow']"+str(gold)+"[/color][/b][/font_size]"
