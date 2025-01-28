class_name LevelTimeComponent extends Node

@export var INGAME_SPEED = 1.0
@export var INITIAL_HOUR = 12:
	set(h):
		INITIAL_HOUR = h
		current_time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR

var current_time : float =  0.0
var past_minute  : float = -1.0  ## Avoid recalculating all this every frame.

const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY


func _ready():
	current_time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR


func _process(delta: float) -> void:
	current_time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
	_recalculate_time()


func _recalculate_time() -> void:
	var tot_mins = int(current_time / INGAME_TO_REAL_MINUTE_DURATION)  # total_minutes
	var day_mins = tot_mins % MINUTES_PER_DAY                          # current_day_minutes
	var minute   = int(day_mins % MINUTES_PER_HOUR)
	if past_minute != minute:
		var day = int(tot_mins / MINUTES_PER_DAY)
		var hour = int(day_mins / MINUTES_PER_HOUR)
		past_minute = minute
		SignalManager.time_tick.emit(day, hour, minute)
