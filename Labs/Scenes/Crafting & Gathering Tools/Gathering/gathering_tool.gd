class_name GatheringTool extends Tool
## Nature's worst nightmare.

## Structure should be as follow:
## Tool                             : Marker2D
## > child(0): ToolArea             : Area2D
## > > child(0): ToolCollisionShape : CollisionShape2D
## > child(1): Pivot                : Marker2D
## > > child(0): ToolSprite         : Sprite2D
## > child(2): PickaxePlayer        : AnimationPlayer

signal gather_finished()  ## Emitted after the weapon's attack ends.

var tool_stats = {
	GameEnums.TOOL_STAT.SPEED     :   1,      # speed_scale = [-4, 4] in Godot
	GameEnums.TOOL_STAT.DAMAGE    :  10,
}


## Prepares the tool by hiding it and updating its speed stat from a database.
func _ready():
	#get_child(1).get_child(0).visible = false
	get_child(0).monitoring = false
	get_child(2).speed_scale = tool_stats[GameEnums.TOOL_STAT.SPEED]


func _on_pickaxe_player_animation_finished(anim_name: StringName) -> void:
	gather_finished.emit()
