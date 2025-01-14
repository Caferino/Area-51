extends Alcarodia
## Bizck, the [color=green]God of Nature.

const PLANT            : PackedScene = preload("res://Labs/Scenes/Interactive Decorations Room/Ground Items/plants/plant.tscn")
const LEAVES_PARTICLES : PackedScene = preload("res://Labs/Scenes/Farming Room/leaves_particles.tscn")  # TODO - Migration

var leaves: Dictionary = {
	0: {
		"texture" = preload("res://Labs/Scenes/Farming Room/leaf.png")  # TODO - Migration
	},
}

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
			"leaves_id" = 0,
			"leaves_amount" = 8,
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
			"leaves_id" = 0,
			"leaves_amount" = 8,
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
			"leaves_id" = 0,
			"leaves_amount" = 8,
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
			"leaves_id" = 0,
			"leaves_amount" = 8,
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
			"leaves_id" = 0,
			"leaves_amount" = 8,
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
			"leaves_id" = 0,
			"leaves_amount" = 8,
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
			"leaves_id" = 0,
			"leaves_amount" = 8,
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
			"leaves_id" = 0,
			"leaves_amount" = 8,
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


func create_plant(plant_name: String = "", animated: bool = false, random_growth: bool = false) -> Plant:
	var plant            = PLANT.instantiate()
	var leaves_particles = LEAVES_PARTICLES.instantiate()
	
	## Plant Setup
	var plant_path = static_plants["weeds"][plant_name]  # TODO - "weeds" will be a variable
	plant.name = plant_path["name"]                    ## Plant Name
	plant.growth_stages = plant_path["growth_stages"]  ## Growth Stages
	plant.margin_x = plant_path["margin_x"]            ## Margin x
	plant.margin_y = plant_path["margin_y"]            ## Margin y
	
	## Sprite Setup
	var sprite = Sprite2D.new()
	print(sprite.name)
	if animated:
		# TODO - Similar to static, it's just the frames that work different
		pass
	else:
		sprite.name    = "PlantSprite"  # TODO - Create one for Trunk, one for Leaves someday for dynamic trees
		sprite.texture = plant_path["texture"]
		sprite.hframes = plant_path["hframes"]
		sprite.vframes = plant_path["vframes"]
		sprite.offset  = Vector2(0, plant_path["offset_y"])
		sprite.y_sort_enabled = true
		if random_growth:
			plant.current_stage = randi_range(0, plant.growth_stages)
			sprite.frame        = plant.current_stage
	
	## Leaves Setup
	leaves_particles.amount = plant_path["leaves_amount"]
	var leaves_path = leaves[plant_path["leaves_id"]]
	leaves_particles.texture = leaves_path["texture"]
	
	plant.add_child(sprite)
	plant.add_child(leaves_particles)
	plant.setup()
	return plant










############ MAYBE DEPRECATED #####################
#var animals: Dictionary = {
	#"CaveBat" = {
		#GameEnums.AI_STAT.DEFAULT_MAX_SPEED      : 250,
		#GameEnums.AI_STAT.DEFAULT_LOOK_AHEAD     :  50,
		#GameEnums.AI_STAT.DEFAULT_ADDED_INTEREST : 5.0,
		#GameEnums.AI_STAT.DEFAULT_NUM_RAYS       :   8, # TODO - Maybe this should never change at all for most entities (1)
		#GameEnums.AI_STAT.DEFAULT_BACKOFF_SPEED  : 0.2
	#}
#}
#
#

