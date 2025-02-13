extends ScaleControl

var item: Item: set = set_item


## Set the dragged item
func set_item(value):
	item = value
	
	for c in get_children():
		c.queue_free()
	
	if item:
		add_child(AlcarodianResourceManager.get_item_node(item))
