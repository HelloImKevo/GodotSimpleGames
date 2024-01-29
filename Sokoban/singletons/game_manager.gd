extends Node
## GameManager : Assists with game scene navigation.


const MAIN_SCENE: PackedScene = preload("res://main/main.tscn")
const LEVEL_SCENE: PackedScene = preload("res://level/level.tscn")

var _level_selected: String = "1"


func _ready():
	SignalManager.on_level_selected.connect(on_level_selected)


func get_level_selected() -> String:
	return _level_selected


func on_level_selected(level_number: String) -> void:
	_level_selected = level_number
	get_tree().change_scene_to_packed(LEVEL_SCENE)


func load_main_scene() -> void:
	get_tree().change_scene_to_packed(MAIN_SCENE)
