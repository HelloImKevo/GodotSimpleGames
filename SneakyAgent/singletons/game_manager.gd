extends Node
## GameManager

const MAIN: PackedScene = preload("res://scenes/main.tscn")
const LEVEL_MAP: PackedScene = preload("res://level_map/level_map.tscn")


func load_main_scene():
	get_tree().change_scene_to_packed(MAIN)


func load_game_scene():
	get_tree().change_scene_to_packed(LEVEL_MAP)
