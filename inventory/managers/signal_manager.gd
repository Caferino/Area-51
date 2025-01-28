extends Node
## The [color=white]Signal Manager.

## TODO - I don't like to guess what could be the type of these variables.
## Not sure if some of them deal with multiple different types, but if they
## don't, I should clarify it here, make this more readable and easy to maintain.

# Inventory
signal inventory_opened(inventory)
signal inventory_closed(inventory)
signal inventory_ready(inventory)
signal item_dropped(item)
signal upgrade_item()
signal inventory_group_content_changed(groups)
signal cooldown_started(usable)

# Structure Manager
signal spot_check()

# Interactables
signal crafting_opened(crafting_list_id)
signal crafting_out_of_range()

# UI
signal ui_scale_changed(value)

# Player
signal player_life_changed(life, max_life)
# listen to:
signal heal_player(health_points)

# Save Manager
signal saving_game()

# Level Manager
signal connect_levels(level:Level)
signal time_tick(day:int, hour:int, minute:int)

## Created by me, to connect the player/world/entities with the UI
signal in_entity_vision_area(entered:bool)
signal entity_order(order:int)  ## Maybe change to String/StringName
