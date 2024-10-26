class_name AppearanceComponent extends Node2D
## An object's [color=lime]appearance.

var assets: Dictionary = {}  ## All the pieces that make up the object's appearance.

## Registers all the assets that make up the object's appearance.
func _ready():
	for asset in get_children():
		assets[asset.name] = asset
