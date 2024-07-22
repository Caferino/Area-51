extends Alcarodia
## Bizck, the [color=green]God of Nature.

const PLANT : PackedScene = preload("res://Labs/Scenes/Interactive Decorations Room/Ground Items/plants/plant.tscn")


func create_plant(plant_name: String = "", animated: bool = false, random_growth: bool = false) -> Plant:
	var plant = PLANT.instantiate()
	var plant_path = static_plants["weeds"][plant_name]
	
	## Name
	plant.name = plant_path["name"]
	
	## Growth Stages
	plant.growth_stages = plant_path["growth_stages"]
	
	## Margins
	plant.margin_x = plant_path["margin_x"]
	plant.margin_y = plant_path["margin_y"]
	
	## Sprite
	var sprite = Sprite2D.new()
	if animated:
		pass
	else:
		sprite.texture = plant_path["texture"]
		sprite.hframes = plant_path["hframes"]
		sprite.vframes = plant_path["vframes"]
		sprite.offset  = Vector2(0, plant_path["offset_y"])
		sprite.y_sort_enabled = true
		if random_growth:
			plant.current_stage = randi_range(0, plant.growth_stages)
			sprite.frame        = plant.current_stage
	plant.add_child(sprite)
	
	return plant




## NOTE - To load or to preload... We'll see
var static_plants: Dictionary = {
	trees = {
		oak = {
			"name" = "Oak Tree"
		}
	},
	weeds = {
		weed1 = {
			"name" = "Agavia",
			"growth_stages" = 7,
			"texture" = preload("res://Labs/Scenes/Interactive Decorations Room/Ground Items/plants/weeds/weed1.png"),
			"leaves" = null,  # TODO - CREATE GROUPS OF THESE INSTEAD, REPETITIVE AMONGST PLANTS
			"hframes" = 2,
			"vframes" = 4,
			"margin_x" = 5,
			"margin_y" = 8,
			"offset_y" = -6
		},
		weed2 = {
			"name" = "Agavia",
			"growth_stages" = 7,
			"texture" = preload("res://Labs/Scenes/Interactive Decorations Room/Ground Items/plants/weeds/weed2.png"),
			"leaves" = null,  # TODO - Probably needed if unique leaves particles
			"hframes" = 2,
			"vframes" = 4,
			"margin_x" = 5,
			"margin_y" = 8,
			"offset_y" = -6
		},
		weed3 = {
			"name" = "Agavia",
			"growth_stages" = 7,
			"texture" = preload("res://Labs/Scenes/Interactive Decorations Room/Ground Items/plants/weeds/weed3.png"),
			"leaves" = null,  # TODO - Probably needed if unique leaves particles
			"hframes" = 2,
			"vframes" = 4,
			"margin_x" = 5,
			"margin_y" = 8,
			"offset_y" = -6
		},
		weed4 = {
			"name" = "Agavia",
			"growth_stages" = 7,
			"texture" = preload("res://Labs/Scenes/Interactive Decorations Room/Ground Items/plants/weeds/weed4.png"),
			"leaves" = null,  # TODO - Probably needed if unique leaves particles
			"hframes" = 2,
			"vframes" = 4,
			"margin_x" = 5,
			"margin_y" = 8,
			"offset_y" = -6
		},
		weed5 = {
			"name" = "Agavia",
			"growth_stages" = 7,
			"texture" = preload("res://Labs/Scenes/Interactive Decorations Room/Ground Items/plants/weeds/weed5.png"),
			"leaves" = null,  # TODO - Probably needed if unique leaves particles
			"hframes" = 2,
			"vframes" = 4,
			"margin_x" = 5,
			"margin_y" = 8,
			"offset_y" = -6
		},
		weed6 = {
			"name" = "Agavia",
			"growth_stages" = 7,
			"texture" = preload("res://Labs/Scenes/Interactive Decorations Room/Ground Items/plants/weeds/weed6.png"),
			"leaves" = null,  # TODO - Probably needed if unique leaves particles
			"hframes" = 2,
			"vframes" = 4,
			"margin_x" = 5,
			"margin_y" = 8,
			"offset_y" = -6
		},
		weed7 = {
			"name" = "Agavia",
			"growth_stages" = 7,
			"texture" = preload("res://Labs/Scenes/Interactive Decorations Room/Ground Items/plants/weeds/weed7.png"),
			"leaves" = null,  # TODO - Probably needed if unique leaves particles
			"hframes" = 2,
			"vframes" = 4,
			"margin_x" = 5,
			"margin_y" = 8,
			"offset_y" = -6
		},
		weed8 = {
			"name" = "Agavia",
			"growth_stages" = 7,
			"texture" = preload("res://Labs/Scenes/Interactive Decorations Room/Ground Items/plants/weeds/weed8.png"),
			"leaves" = null,  # TODO - Probably needed if unique leaves particles
			"hframes" = 2,
			"vframes" = 4,
			"margin_x" = 5,
			"margin_y" = 8,
			"offset_y" = -6
		},
	},
	bushes = {
		blueberry = {
			"name" = "Blueberry Bush"
		},
		blackberry = {
			"name" = "Blackberry Bush"
		}
	},
	flowers = {
		antulio = {
			"name" = "Antúlio"
		}
	}
}






############ MAYBE DEPRECATED #####################
#var animals: Dictionary = {
	#"CaveBat" = {
		#GameEnums.AI_STATS.DEFAULT_MAX_SPEED      : 250,
		#GameEnums.AI_STATS.DEFAULT_LOOK_AHEAD     :  50,
		#GameEnums.AI_STATS.DEFAULT_ADDED_INTEREST : 5.0,
		#GameEnums.AI_STATS.DEFAULT_NUM_RAYS       :   8, # TODO - Maybe this should never change at all for most entities (1)
		#GameEnums.AI_STATS.DEFAULT_BACKOFF_SPEED  : 0.2
	#}
#}
#
#

