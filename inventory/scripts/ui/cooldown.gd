extends TextureProgressBar

var item_usable


## Set the value of the progress
func set_data(usable):
	item_usable = usable
	max_value = usable.cooldown
	
	if usable.is_in_cooldown:
		value = usable.cooldown_remaining


func _process(_delta):
	value = item_usable.cooldown_remaining
	%Label.text = "%0.2f" % item_usable.cooldown_remaining
	
	if item_usable.cooldown_remaining <= 0:
		queue_free()
