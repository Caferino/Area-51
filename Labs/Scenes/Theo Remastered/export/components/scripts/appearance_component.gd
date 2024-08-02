class_name AppearanceComponent extends Node2D
## An object or interactable's [color=lime]appearance.

var assets: Dictionary = {}


func _ready():
	for asset in get_children():
		assets[asset.name] = asset
