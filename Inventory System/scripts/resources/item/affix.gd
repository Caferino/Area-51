class_name Affix extends Resource

var id          : String
var min_level   : int
var affix_name  : String
var stat_ranges : Array


func _init(affix_id, data):
	id = affix_id
	affix_name = data.affix_name
	min_level = data.min_level
	stat_ranges = []
	
	for stat_range_data in data.stat_ranges:
		stat_ranges.append(StatRange.new(stat_range_data))
