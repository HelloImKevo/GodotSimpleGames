extends Node
## GameManager : game_manager.gd

const GROUP_PLAYER: String = "player"

const TOTAL_LEVELS: int = 3
const MAIN_SCENE: PackedScene = preload("res://main/main.tscn")

## Index of the current level.
var _current_level: int = 0
var _highest_level_reached: int = 0
var _level_scenes: Dictionary = {}


func resume_game() -> void:
	Engine.time_scale = 1
	# Note: This will actually pause input processing for the Player / HUD.
	# Additionally, it will pause AudioStreamPlayers in the tree, causing
	# all the Music to stop.
	# get_tree().paused = false


func pause_game() -> void:
	Engine.time_scale = 0
	# get_tree().paused = true


func get_current_level() -> int:
	return _current_level


# Virtual override.
func _ready() -> void:
	_init_level_scenes()
	ScoreManager.reset_score()


func _init_level_scenes() -> void:
	for ln in range(1, TOTAL_LEVELS + 1):
		_level_scenes[ln] = load("res://level_base/levels/level_%s.tscn" % ln)


func load_main_scene() -> void:
	_current_level = 0
	get_tree().change_scene_to_packed(MAIN_SCENE)


func load_next_level_scene() -> void:
	set_next_level()
	get_tree().change_scene_to_packed(_level_scenes[_current_level])


func set_next_level() -> void:
	_current_level += 1
	if _current_level > TOTAL_LEVELS:
		# Reset back to the first level.
		_current_level = 1
	_highest_level_reached = _current_level
