class_name Scorer
extends Node
## Scorer : scorer.gd


@onready var sound = $Sound
@onready var reveal_timer = $RevealTimer

var _selections: Array[MemoryTile] = []
var _target_pairs: int = 0
var _moves_made: int = 0
var _pairs_made: int = 0


func _to_string() -> String:
	return "Scorer"


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_tile_selected.connect(_on_tile_selected)
	SignalManager.on_game_exit_pressed.connect(_on_game_exit_pressed)


func get_moves_made_str() -> String:
	return str(_moves_made)


func get_pairs_made_str() -> String:
	return "%s / %s" % [_pairs_made, _target_pairs]


func clear_new_game(target_pairs: int) -> void:
	print(_to_string(), ": clear_new_game() -> target_pairs: %d" % [target_pairs])
	_selections.clear()
	_pairs_made = 0
	_moves_made = 0
	_target_pairs = target_pairs


func _on_game_exit_pressed() -> void:
	# Prevent race condition resulting in a null _selections (because the Nodes
	# have queue_free() invoked by the GameManager).
	reveal_timer.stop()


func _selections_are_pair() -> bool:
	var first: MemoryTile = _selections[0]
	var second: MemoryTile = _selections[1]
	
	return (
		first.get_instance_id() != second.get_instance_id()
		and
		first.get_item_name() == second.get_item_name()
	)


func _update_selections() -> void:
	reveal_timer.start()
	if _selections_are_pair():
		_kill_selected_tiles()


func _kill_selected_tiles() -> void:
	for s in _selections:
		s.kill_on_success()
	
	_pairs_made += 1
	SoundManager.play_sfx(sound, SoundManager.SOUND_SUCCESS)


func _on_tile_selected(tile: MemoryTile) -> void:
	SoundManager.play_tile_click(sound)
	_check_pair_made(tile)


func _check_pair_made(tile: MemoryTile) -> void:
	tile.reveal(true)
	_selections.append(tile)
	if _selections.size() != 2:
		return
	
	SignalManager.on_selection_disabled.emit()
	_moves_made += 1
	
	_update_selections()


func hide_selections() -> void:
	for s in _selections:
		s.reveal(false)


func _on_reveal_timer_timeout():
	if !_selections_are_pair():
		hide_selections()
	_selections.clear()
	_check_game_over()
	SignalManager.on_selection_enabled.emit()


func _check_game_over() -> void:
	if _pairs_made >= _target_pairs:
		SignalManager.on_game_over.emit(_moves_made)
