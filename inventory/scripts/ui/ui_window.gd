class_name UIWindow extends DragableControl

var title : set = set_title


func set_title(value):
	title = value
	%lbl_title.text = title


func close():
	hide()


func _on_close_pressed():
	close()
