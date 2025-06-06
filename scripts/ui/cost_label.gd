class_name CostLabel extends RichTextLabel

func update(cost : int) -> void:
	var color = "white"
	if cost > GameManager.gold:
		color = "red"
	text="[font_size='14']Cost: [b][color='"+str(color)+"']"+str(cost)+"[/color][/b][/font_size]"
