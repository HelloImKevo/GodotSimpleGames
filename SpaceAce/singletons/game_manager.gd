extends Node
## GameManager : Manages scene transitions, and other things.


var main_scene: PackedScene = preload("res://main/main.tscn")
var level_scene: PackedScene = preload("res://level/level.tscn")


func load_main_scene() -> void:
	# Workaround for error. Could alternatively use call_deferred("func", arg1, arg2)
	# game_manager.gd:11 @ load_main_scene(): This function can't be used during the in/out signal.
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(main_scene)


func load_level_scene() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(level_scene)
