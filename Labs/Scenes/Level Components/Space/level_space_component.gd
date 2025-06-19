class_name SpaceComponent extends Node2D
## This Node must have the following children:
# Fields - For plants and trees.
# Items - Dropped or spawned.
# Entities - Everything that moves.
# Tilemaps - The visual world.
# Interactables - Objects entities can interact with.
# StaticDecor - Static granular decorations.
# ReactiveDecor - Decorations that react to external forces (weather, wind...).


# NOTE TODO - Wind's forces apply to Fields and ReactiveDecor

@export var entities       : Node2D = null
@export var items          : Node2D = null
@export var fields         : Node2D = null
@export var tilemaps       : Node2D = null
@export var interactables  : Node2D = null
@export var static_decor   : Node2D = null
@export var reactive_decor : Node2D = null
@export var spawners       : Node2D = null
@export var weather        : Node2D = null

@export var gather_nodes   : Node2D = null
@export var craft_nodes    : Node2D = null
@export var doors          : Node2D = null
@export var start          : Marker2D = null
