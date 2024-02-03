extends Node
## GameManager : Manages scene transitions, and other things.


var main_scene: PackedScene = preload("res://main/main.tscn")
var level_scene: PackedScene = preload("res://level/level.tscn")


func load_main_scene() -> void:
	get_tree().change_scene_to_packed(main_scene)


func load_level_scene() -> void:
	get_tree().change_scene_to_packed(level_scene)
