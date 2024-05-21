class_name HumanoidStaminaComponent extends Node

var stats = {
	GameEnums.STAMINA_STATS.CAPACITY         : 100,  # %
	GameEnums.STAMINA_STATS.SPRINT_RATE      :   2,  # -units/s
	GameEnums.STAMINA_STATS.REGEN_RATE       :   3,  # +units/s  # TODO - Small pause b4 recharging
	GameEnums.STAMINA_STATS.MAX_WALK_SPEED   :  10,
	GameEnums.STAMINA_STATS.WALK_ACCEL       :   2,
	GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED :  20,
	GameEnums.STAMINA_STATS.SPRINT_ACCEL     :  15,
	GameEnums.STAMINA_STATS.DEACCEL          :   6,
}


func setup(n : Dictionary):
	stats[GameEnums.STAMINA_STATS.CAPACITY]         = n[GameEnums.STAMINA_STATS.CAPACITY]
	stats[GameEnums.STAMINA_STATS.SPRINT_RATE]      = n[GameEnums.STAMINA_STATS.SPRINT_RATE]
	stats[GameEnums.STAMINA_STATS.REGEN_RATE]       = n[GameEnums.STAMINA_STATS.REGEN_RATE]
	stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED]   = n[GameEnums.STAMINA_STATS.MAX_WALK_SPEED]
	stats[GameEnums.STAMINA_STATS.WALK_ACCEL]       = n[GameEnums.STAMINA_STATS.WALK_ACCEL]
	stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED] = n[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED]
	stats[GameEnums.STAMINA_STATS.SPRINT_ACCEL]     = n[GameEnums.STAMINA_STATS.SPRINT_ACCEL]
	stats[GameEnums.STAMINA_STATS.DEACCEL]          = n[GameEnums.STAMINA_STATS.DEACCEL]

func get_capacity():                  return stats[GameEnums.STAMINA_STATS.CAPACITY]
func set_capacity(amount):            stats[GameEnums.STAMINA_STATS.CAPACITY] = amount

func get_sprint_rate():               return stats[GameEnums.STAMINA_STATS.SPRINT_RATE]
func set_sprint_rate(amount):         stats[GameEnums.STAMINA_STATS.SPRINT_RATE] = amount

func get_regen_rate():                return stats[GameEnums.STAMINA_STATS.REGEN_RATE]
func set_regen_rate(amount):          stats[GameEnums.STAMINA_STATS.REGEN_RATE] = amount

func get_max_walk_speed():            return stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED]
func set_max_walk_speed(amount):      stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED] = amount

func get_walk_accel():                return stats[GameEnums.STAMINA_STATS.WALK_ACCEL]
func set_walk_accel(amount):          stats[GameEnums.STAMINA_STATS.WALK_ACCEL] = amount

func get_max_sprint_speed():          return stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED]
func set_max_sprint_speed(amount):    stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED] = amount

func get_sprint_acceleration():       return stats[GameEnums.STAMINA_STATS.SPRINT_ACCEL]
func set_sprint_acceleration(amount): stats[GameEnums.STAMINA_STATS.SPRINT_ACCEL] = amount

func get_deacceleration():            return stats[GameEnums.STAMINA_STATS.DEACCEL]
func set_deacceleration(amount):      stats[GameEnums.STAMINA_STATS.DEACCEL] = amount
