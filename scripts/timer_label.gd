extends RichTextLabel

var contor = 1

func _ready() -> void:
	text = "[font_size='14'][b][color='white']"+str(contor)+"[/color][/b][/font_size]"
	
func _on_timer_timeout() -> void:
	contor = contor + 1
	text = "[font_size='14'][b][color='white']"+str(contor)+"[/color][/b][/font_size]"
