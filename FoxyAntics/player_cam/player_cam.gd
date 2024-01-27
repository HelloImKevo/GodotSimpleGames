extends Camera2D

@export var shake_enabled: bool = true
@export var shake_amount: float = 3.0

@onready var shake_timer = $ShakeTimer


func _ready():
	set_process(false)
	SignalManager.on_player_hit.connect(_on_player_hit)
	SignalManager.on_game_over.connect(_on_game_over)


func _process(_delta):
	offset = get_random_offset()


func get_random_offset() -> Vector2:
	return Vector2(
		randf_range(-shake_amount, shake_amount),
		randf_range(-shake_amount, shake_amount)
	)


func shake() -> void:
	set_process(true)
	shake_timer.start()


func _on_player_hit(_hit_points: int) -> void:
	if shake_enabled:
		shake()


func _on_shake_timer_timeout() -> void:
	_reset_camera()


func _on_game_over() -> void:
	_reset_camera()


func _reset_camera() -> void:
	set_process(false)
	offset = Vector2.ZERO
