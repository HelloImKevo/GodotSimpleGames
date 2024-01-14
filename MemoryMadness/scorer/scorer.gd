class_name Scorer
extends Node
## Scorer : scorer.gd


@onready var sound = $Sound
@onready var reveal_timer = $RevealTimer

var _tiles: Array = []
var _selections: Array = []
var _target_pairs: int = 0
var _moves_made: int = 0
var _pairs_made: int = 0


func _to_string() -> String:
	return "Scorer"


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_tile_selected.connect(_on_tile_selected)
	SignalManager.on_game_exit_pressed.connect(_on_game_exit_pressed)


func clear_new_game(target_pairs: int) -> void:
	print(_to_string(), ": clear_new_game() -> target_pairs: %d" % [target_pairs])
	_selections.clear()
	_pairs_made = 0
	_moves_made = 0
	_target_pairs = target_pairs
	_tiles = get_tree().get_nodes_in_group(GameManager.GROUP_TILE)


func _on_game_exit_pressed() -> void:
	# Prevent race condition resulting in a null _selections (because the Nodes
	# have queue_free() invoked by the GameManager).
	reveal_timer.stop()


func _update_selections() -> void:
	reveal_timer.start()


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
	hide_selections()
	_selections.clear()
	SignalManager.on_selection_enabled.emit()
