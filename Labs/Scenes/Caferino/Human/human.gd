class_name Human extends Entity
## A [color=pink]human being[/color], by [color=brown]Caferino.

@export var lore        : LoreComponent              ## The entity's [color=ivory]lore.
@export var health      : HealthComponent            ## The entity's [color=red]heart.
@export var muscles     : HumanoidMovementComponent  ## The entity's [color=salmon]muscles.
@export var controller  : EntityController           ## The entity's [color=gray]controller.
@export var body        : BodyComponent              ## The entity's [color=blue]body.
@export var inventory   : InventoryComponent         ## The entity's [color=brown]inventory.


## Spawns the entity.
func _ready():
	body_pose["Head"]          = [Vector2(0, -13), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	body_pose["Torso"]         = [Vector2(0, 0), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 2.0]
	
	body_accessories["Hat"]    = [Vector2(0, -9), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	body_accessories["Weapon"] = [Vector2(0, 0), -90, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	spawn()


## Connects the entity's component signals.
func spawn():
	body.gear["MeleeWeapon"].attack_finished.connect(_on_attack_finished)
	body.limb_interact.connect(_on_limb_interact)
	muscles.stopped_moving.connect(_on_entity_stop)
	controller.entity_move.connect(_on_entity_move)
	controller.entity_sprint.connect(_on_entity_sprint)
	controller.entity_attack.connect(_on_entity_attack)
	controller.entity_interact.connect(_on_entity_interact)
	
	muscles.handle_animation(self, controller.dir, controller.sprinting)
	print(name, " is waking up")  # DEBUG


## Handles the entity's movement every physics frame.
func _physics_process(_delta: float) -> void:
	if !controller.attacking:
		muscles.handle_movement(self, controller.dir, controller.sprinting)
		controller.rotate_interactor(muscles.last_direction)


## Runs whenever the entity starts moving.
func _on_entity_move():
	controller.on_move()


## Runs whenever the entity starts running.
func _on_entity_sprint():
	controller.on_sprint()


## Runs whenever the entity stops moving.
func _on_entity_stop():
	controller.on_stop()


## Runs whenever the entity attacks.
func _on_entity_attack():
	if !controller.attacking:
		controller.on_attack()
		muscles.stop(self, true)
		muscles.attack(body.gear["MeleeWeapon"], body.limbs["Torso"].animator, body.limbs["Head"].animator)


## Runs after the entity's most recent attack ends.
func _on_attack_finished():
	controller.on_attack_finished()


## Runs whenever a body limb interacts with something.
func _on_limb_interact(entered: bool, limb_name: String, area: Area2D):
	if area.is_in_group("Plant"):
		if limb_name == "LeftLeg":
			if entered : area.get_parent().interact(-0.1, 0.2, "shake")
			else       : area.get_parent().interact( 0.0, 0.2, "tilt_back")
		elif limb_name == "RightLeg":
			if entered : area.get_parent().interact( 0.1, 0.2, "shake")
			else       : area.get_parent().interact( 0.0, 0.2, "tilt_back")
	


## Runs whenever the player (if controlled by one), interacts with something.
func _on_entity_interact():
	var interactables = controller.interactor_area.get_overlapping_areas()
	for interactable in interactables:
		if interactable.is_in_group("Interactive"):
			if interactable.is_in_group("Tree"):
				interactable.get_parent().interact("hatchet")
