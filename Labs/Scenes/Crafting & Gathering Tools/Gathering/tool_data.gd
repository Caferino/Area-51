class_name ToolData extends Resource
## A basic tool.

@export var texture    : Texture2D = null  ## Tool's appearance
@export var type       : GameEnums.TOOL_TYPE
@export var name       : String    = ""
@export var swings     : bool      = false
@export var speed      : float     = 1.0
@export var damage     : float     = 1.0
@export var knockback  : float     = 0.0
@export var durability : float     = 100.0
