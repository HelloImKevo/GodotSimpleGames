extends Node


## GameManager : game_manager.gd
##
## Created by right-clicking on the 'singletons' dir, and clicking
## 'Create Script'. Then, under Project Settings, select the Autoload tab.
## Then choose the game_manager.gd file, and name the Node 'GameManager'
## and finally click the [ADD] button. By default the 'Global Variable'
## checkbox will already be checked.


# Signal Hub / Event Bus / Event Manager.
signal on_game_over
signal on_score_updated


const GROUP_PLANE: String = "plane"


const KEY_HIGH_SCORE: String = "high_score"


# Load at compile time (baked into game).
var game_scene: PackedScene = preload("res://game/game.tscn")
var main_scene: PackedScene = preload("res://main/main.tscn")


var _save_data: Dictionary = {}


var _score: int = 0
var _high_score: int = 0


func _ready():
	print("GameManager is loading save data ...")
	var json: String = DataHelper.load()
	if json == null or json.is_empty():
		print("No save data available")
	else:
		_save_data = JSON.parse_string(json)
		print_debug("Loaded Save Data: %s" % [_save_data])
		load_save_data(_save_data)


func load_save_data(data: Dictionary) -> void:
	if data.has(KEY_HIGH_SCORE):
		_high_score = int(data.get(KEY_HIGH_SCORE))


func get_score() -> int:
	return _score


func set_score(v: int) -> void:
	print("Updating score to %d" % [v])
	_score = v
	if _score > _high_score:
		print("Updating new high score of %d" % [_score])
		_high_score = _score
		_save_high_score(_high_score)
	on_score_updated.emit()


func _save_high_score(high_score: int) -> void:
	var save_dict = {
		"high_score" : high_score
	}
	DataHelper.save(JSON.stringify(save_dict))


func increment_score() -> void:
	set_score(_score + 1)


func get_high_score() -> int:
	return _high_score


# Load the main Game Loop scene.
func load_game_scene() -> void:
	# Change to our main game scene (Plane with scrolling pipes).
	get_tree().change_scene_to_packed(game_scene)


# Load the Main Menu.
func load_main_scene() -> void:
	get_tree().change_scene_to_packed(main_scene)
