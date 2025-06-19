class_name GatheringNodeData extends Resource
## A basic gathering node.

@export var texture     : Texture2D = null  ## Tool's appearance
@export var type        : GameEnums.NODE_TYPE
@export var name        : String    = ""
@export var resource    : String    = ""    ## "Coal Ore" -> "coal", lowercase, for the ResourcePreloader
@export var health      : float     = 100.0
@export var max_health  : float     = 100.0
@export var loot_radius : Vector2   = Vector2(30.0, 30.0)
@export var drop_rate   : Vector2i  = Vector2(1, 3)  ## Randomly drop from 1 to 3 reagents.
