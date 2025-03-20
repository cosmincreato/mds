class_name CostLabel extends RichTextLabel

func update(cost : int) -> void:
	var color = "white"
	if cost > GameManager.gold:
		color = "red"
	text="[font_size='70']Cost: [b][color='"+str(color)+"']"+str(cost)+"[/color][/b][/font_size]"
