class_name SoundComponent extends Node2D
## The range of emitted sounds by the entity or object.

## WARN - This node has to be of type Node2D for the Area2D to be detected or work at all.
## For some reason, Area2Ds inside a Node only don't get detected or collision with anything.
## Weird ass design choice I don't understand nor like. Doesn't works either if you have
## a Node parent with a Node2D child with the Area2D inside that Node2D. It won't; Node has to be
## a Node2D forcefully to let that Area2D work. It breaks my heart.
