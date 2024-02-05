class_name WaveListResource
extends Resource
## WaveListResource : List of enemy wave parameters.


@export var waves: Array[WaveResource]
@export var wave_gap: float
@export var speed_factor: float

var _current_wave: int = 0


func get_next_wave() -> WaveResource:
	if _current_wave == waves.size():
		_current_wave = 0
	
	var index = _current_wave
	_current_wave += 1
	
	return waves[index]
