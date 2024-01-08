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


# Load at compile time (baked into game).
var game_scene: PackedScene = preload("res://game/game.tscn")
var main_scene: PackedScene = preload("res://main/main.tscn")


var _score: int = 0
var _high_score: int = 0


func get_score() -> int:
	return _score


func set_score(v: int) -> void:
	print("Updating score to %d" % [v])
	_score = v
	if _score > _high_score:
		print("Updating new high score of %d" % [_score])
		_high_score = _score
	on_score_updated.emit()


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
