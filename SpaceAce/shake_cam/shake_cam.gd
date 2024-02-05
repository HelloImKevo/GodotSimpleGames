extends Camera2D


@onready var timer = $Timer

const SHAKE_RANGE: Vector2 = Vector2(-5.0, 5.0)

var _shake_offset: Vector2 = Vector2.ZERO


func _ready():
	_shake_offset = offset
	SignalManager.on_player_hit.connect(on_player_hit)
	# Stop shaking.
	set_process(false)


func _process(delta):
	offset = Vector2(
		_shake_offset.x + get_random_shake_amount(),
		_shake_offset.y + get_random_shake_amount()
	)


func get_random_shake_amount() -> float:
	return randf_range(SHAKE_RANGE.x, SHAKE_RANGE.y)


func on_player_hit(_v: int) -> void:
	set_process(true)
	timer.start()


func _on_timer_timeout():
	# Stop shaking.
	set_process(false)
	offset = _shake_offset
