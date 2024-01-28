extends Node
## ScoreManager : Singleton for managing player scores.


## Alias for an OS-specific directory.
## See: https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html
##
## Windows: %APPDATA%\Godot\app_userdata\[project_name]
## macOS: ~/Library/Application Support/Godot/app_userdata/[project_name]
## Linux: ~/.local/share/godot/app_userdata/[project_name]
const HS_FILE: String = "user://SCORES.dat"
const HS_KEY: String = "high_score"

var _score: int = 0
var _high_score: int = 0


'''
signal on_enemy_killed(points: int, enemy_position: Vector2)
signal on_pickup_hit(points: int)
signal on_boss_killed(points: int)
signal on_level_complete(level: int)
signal on_game_over
'''


func _to_string() -> String:
	return "ScoreManager"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_high_score()
	SignalManager.on_enemy_killed.connect(on_enemy_killed)
	SignalManager.on_pickup_hit.connect(on_pickup_hit)
	SignalManager.on_boss_killed.connect(on_boss_killed)
	SignalManager.on_level_complete.connect(on_level_complete)
	SignalManager.on_game_over.connect(on_game_over)


func on_enemy_killed(points: int, _enemy_position: Vector2) -> void:
	update_score(points)


func on_pickup_hit(points: int) -> void:
	update_score(points)


func on_boss_killed(points: int) -> void:
	update_score(points)


func on_level_complete(_level: int) -> void:
	save_high_score()


func on_game_over() -> void:
	save_high_score()


func update_score(points: int) -> void:
	_score += points
	if _high_score < _score:
		_high_score = _score
	print(_to_string(), " => update_score: ", _score)
	SignalManager.on_score_updated.emit()


func get_score() -> int:
	return _score


func get_high_score() -> int:
	return _high_score


func reset_score() -> void:
	_score = 0


func save_high_score() -> void:
	var file = FileAccess.open(HS_FILE, FileAccess.WRITE)
	var json = JSON.stringify({
		HS_KEY: _high_score
	})
	file.store_string(json)
	print(_to_string(), " File => ", HS_FILE, " Saved: ", json)


func load_high_score() -> void:
	if not FileAccess.file_exists(HS_FILE):
		return
	
	var file = FileAccess.open(HS_FILE, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	
	if content == null:
		return
	
	var data: Dictionary = content
	print(_to_string(), " data: ", data)
	if HS_KEY in data:
		_high_score = data[HS_KEY]
		print("loaded _high_score: ", _high_score)
