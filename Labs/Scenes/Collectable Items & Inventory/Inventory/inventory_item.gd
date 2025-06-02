class_name InventoryItem extends Resource
## Static collectable. TODO - AnimatedInventoryItem, just the sprite changes, and create SpriteFrames
## as RESOURCES (.tres) for them, to save memory. E.x. Dragonsoul drops, enchanted items, magic...

@export var texture : Texture2D     = null
@export var name    : String        = ""
@export var groups  : Array[String] = []
