extends Node


## ScoreManager : score_manager.gd
##
## Singleton for managing player scores.


const DEFAULT_SCORE: int = 1000


var _level_scores: Dictionary = {}
var _level_selected: int = 0
var _attempts: int = 0
var _cups_hit: int = 0
var _target_cups: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_cup_destroyed.connect(on_cup_destroyed)

## [codeblock]
## _level_scores = {
##     1: 1000,
##     2: 2000,
##     3: 3000
## }
## [/codeblock]
func check_and_add(level: int) -> void:
	if !_level_scores.has(level):
		_level_scores[level] = DEFAULT_SCORE


func level_selected(level: int) -> void:
	check_and_add(level)
	_level_selected = level
	_attempts = 0
	_cups_hit = 0
	print("level_selected:%s _level_scores:%s" % [_level_selected, _level_scores])


func get_best_for_level(level: int) -> int:
	check_and_add(level)
	return _level_scores[level]


func get_attempts() -> int:
	return _attempts


## Which level number is current selected?
func get_level_selected() -> int:
	return _level_selected


## Specify how many "Target Cups" the Animal must land in, for the current level.
func set_target_cups(t: int) -> void:
	_target_cups = t
	print("set_target_cups: ", _target_cups)


## Should be called each time the [Animal] is launched.
func attempt_made() -> void:
	_attempts += 1
	SignalManager.on_attempt_made.emit()
	print("attempt_made() _target_cups:%s, _attempts:%s, _cups_hit:%s" % [
		_target_cups, _attempts, _cups_hit
	])


## Should be called each time the [Animal] lands inside of a cup, and it gets destroyed.
func on_cup_destroyed() -> void:
	_cups_hit += 1
	print("on_cup_destroyed() _target_cups:%s, _attempts:%s, _cups_hit:%s" % [
		_target_cups, _attempts, _cups_hit
	])
	check_game_over()


## Checks whether the number of cups that have been hit is greater than the specified
## number of target cups (determined by the current [Level]).
func check_game_over() -> void:
	if _cups_hit < _target_cups:
		return

	print("GAME OVER ", _level_scores)
	SignalManager.on_game_over.emit()
	if _level_scores[_level_selected] > _attempts:
		_level_scores[_level_selected] = _attempts
		print("record set: ", _level_scores)
