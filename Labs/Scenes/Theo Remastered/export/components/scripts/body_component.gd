class_name BodyComponent extends Node2D

# This is where shit is gonna get crazy.
# Imagine this BodyComponent starts empty, and you add certain
# limbs depending on the blueprint of the entity. A human would
# require a Head, Torso, LeftLeg, RightLeg (this could become more
# granular in 3D games or more detaile 2D sprites, but I'll keep it
# simple for now). A monster, you could add multiple heads or limbs of the
# same type and create weird interesting shit, but how? What'd be the advantages
# and cons?

signal limb_interact(limb, object)

var limbs = {}


func _ready() -> void:
	connect_limbs()


# TODO - Iterate over children to connect limbs
func connect_limbs():
	for limb in get_children():
		limbs[limb.name] = limb
