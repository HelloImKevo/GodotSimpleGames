extends Node


# Load at compile time (baked into game).
var game_scene: PackedScene = preload("res://game/game.tscn")


func load_game_scene() -> void:
	# Change to our main game scene (Plane with scrolling pipes).
	get_tree().change_scene_to_packed(game_scene)
