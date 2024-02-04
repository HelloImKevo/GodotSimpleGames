extends Node
## ObjectMaker : Handles spawning scenes to the current scene tree on-demand.


enum SCENE_KEY { EXPLOSION, BOOM }

const SIMPLE_SCENES: Dictionary = {
	SCENE_KEY.EXPLOSION: preload("res://explosion/explosion.tscn"),
	SCENE_KEY.BOOM: preload("res://boom/boom.tscn")
}


func add_child_deferred(child_to_add, parent: Node2D) -> void:
	parent.add_child(child_to_add)


func call_add_child(child_to_add, parent: Node2D) -> void:
	call_deferred("add_child_deferred", child_to_add, parent)


func create_simple_scene(start_pos: Vector2, key: SCENE_KEY, parent: Node2D) -> void:
	var new_exp = SIMPLE_SCENES[key].instantiate()
	new_exp.global_position = start_pos
	call_add_child(new_exp, parent)


func create_explosion(start_pos: Vector2, parent: Node2D) -> void:
	create_simple_scene(start_pos, SCENE_KEY.EXPLOSION, parent)


func create_boom(start_pos: Vector2) -> void:
	create_simple_scene(start_pos, SCENE_KEY.BOOM, get_tree().current_scene)
