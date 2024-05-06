class_name AffixItemList extends Resource

var affixes = []  # AffixItem
var rarity  # GameEnums.RARITY


func _init(data, item_rarity):
	rarity = item_rarity
	
	for affix_item_data in data:
		affixes.append(AffixItem.new(affix_item_data))


func set_info(item_info):
	item_info.add_splitter()
	for affix_item in affixes:
		affix_item.set_info(item_info, rarity)
