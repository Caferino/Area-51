class_name HumanoidMovementComponent extends Node

## TODO - Can receive direction and is_sprinting from either the PlayerController
## OR a StateMachine for the NPCs and enemies! Modular crazyness
## DEPENDS on a StaminaComponent forcefully?

## TODO - MovementComponents are a little unique. I am thinking about maybe having
## many different ones in the future: JetpackMovementComponent, GrappleMovementComponent...
## where each of them would have their own StaminaComponent attached, with their
## respective needed values. I can also have a general empty MovementComponent and
## StaminaComponent to attach alone into a character, if such cases exist.
## "Something that has stamina must be able to move, and something that moves must
## have stamina"

@export var stamina : HumanoidStaminaComponent


