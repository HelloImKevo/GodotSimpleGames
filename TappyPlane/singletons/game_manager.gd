extends Node


# Signal Hub / Event Bus / Event Manager.
signal on_game_over


const GROUP_PLANE: String = "plane"


# Load at compile time (baked into game).
var game_scene: PackedScene = preload("res://game/game.tscn")
var main_scene: PackedScene = preload("res://main/main.tscn")


# Load the main Game Loop scene.
func load_game_scene() -> void:
	# Change to our main game scene (Plane with scrolling pipes).
	get_tree().change_scene_to_packed(game_scene)


# Load the Main Menu.
func load_main_scene() -> void:
	get_tree().change_scene_to_packed(main_scene)
