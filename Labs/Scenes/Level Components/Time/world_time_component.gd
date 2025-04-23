extends TimeComponent
## The Fourth Dimension.


func _ready():
	## NOTE - If too fast, the moonlights and sunlights wont work well
	INGAME_SPEED = 0.1  ## A value of 0.1 equals to 10 real-life minutes per in-game hour.
	INITIAL_HOUR = 12
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
