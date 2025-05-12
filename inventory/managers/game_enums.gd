class_name GameEnums

###########################################
### ============== ITEMS ============== ###
###########################################
enum ITEM_TYPE {
	MATERIAL,
	CURRENCY,
	CONSUMABLE,
	EQUIPMENT
}

enum EQUIPMENT_TYPE {
	NONE,
	HEAD,
	CHEST,
	MAIN_HAND,
	OFFHAND
}

enum WEAPON_TYPE {
	SLASH,
	BLUNT
}

enum PROJECTILE {
	TARGET_POSITION,
	TARGET_ENTITY,
	TARGET_CHASE,
	LIFE_TIME,
	SIZE
}



###########################################
### ============ ENTITIES ============= ###
###########################################
enum CAFERINO {
	NONE,
	HUMAN
}

enum BIZCK {
	NONE,
	CAVE_BAT
}

enum RAZEN {
	NONE,
}



###########################################
### ============== STATS ============== ###
###########################################
enum STAT {
	VITALITY,
	STRENGTH,
	INTELLIGENCE,
	DEXTERITY,
	LUCK,
	ALL_STATS,
	LIFE_POINT,
	REGENERATION,
	LIFE_ON_HIT,
	DAMAGE,
	DEFENCE,
	BONUS_EXPERIENCE,
	MOVE_SPEED
}  # TODO - Might deprecate, it's too general. Modularize

enum AI_STAT {
	DEFAULT_MAX_SPEED,
	DEFAULT_STEER_FORCE,
	DEFAULT_LOOK_AHEAD,
	DEFAULT_NUM_RAYS,
	DEFAULT_ADDED_INTEREST,
	DEFAULT_BACKOFF_SPEED
}

enum PLANT_STAT {
	WATER,
	GROWTH_STAGES,
	CURRENT_STAGE,
	CURRENT_ROTATION
}

enum TOOL_STAT {
	SPEED,
	DAMAGE,
	KNOCKBACK
}

enum STAMINA_STAT {
	CAPACITY,
	SPRINT_RATE,
	REGEN_RATE,
	MAX_WALK_SPEED,
	WALK_ACCEL,
	MAX_SPRINT_SPEED,
	SPRINT_ACCEL,
	DEACCEL,
	ROLL_SPEED
}



###########################################
### ============== LEVEL ============== ###
###########################################
enum LEVEL_STAT {
	INTERVAL,
}

enum WEATHER {
	### WIND ###
	WIND_STRENGTH,
	WIND_DIRECTION,
	WIND_FREQUENCY,
	### RAIN ###
	RAIN_STRENGTH,
	RAIN_DIRECTION,
	RAIN_FREQUENCY,
}



###########################################
### ============= AFFIXES ============= ###
###########################################
enum RARITY {
	NORMAL,
	MAGIC,
	RARE,
	UNIQUE
}

enum AFFIX_TYPE {
	PREFIX,
	SUFFIX
}

enum INTERFACE {
	DAMAGEABLE,
	FLAMMABLE
}



###########################################
### ============== MAGIC ============== ###
###########################################
enum ENERGY {
	RED,
	BLUE,
	GREEN,
	YELLOW,
	BLACK,
	PURPLE,
	WHITE,
	AMBER
}

enum SPELLS {
	FIREBALL
}
