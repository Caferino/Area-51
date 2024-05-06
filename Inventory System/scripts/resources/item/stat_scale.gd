class_name StatScale extends Resource

var stat_range: StatRange
var scale: float


func _init(data, value):
	stat_range = StatRange.new(data)
	scale = value


func set_info(item_info, color_id):
	var display = AlcarodianResourceManager.stat_info[stat_range.stat].display
	var value = stat_range.get_value(scale, stat_range.stat)
	var text = display % value
	item_info.add_line(ItemInfoLine.new(text, color_id))


func get_stat(stat):
	return stat_range.get_value(scale, stat)
