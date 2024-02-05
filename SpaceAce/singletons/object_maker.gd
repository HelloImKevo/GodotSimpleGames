extends Node
## ObjectMaker : Handles spawning scenes to the current scene tree on-demand.


enum SCENE_KEY { EXPLOSION, BOOM }

const SIMPLE_SCENES: Dictionary = {
	SCENE_KEY.EXPLOSION: preload("res://explosion/explosion.tscn"),
	SCENE_KEY.BOOM: preload("res://boom/boom.tscn")
}

const POWERUP_SCENE: PackedScene = preload("res://powerup/powerup.tscn")


func get_random_powerup():
	return GameData.POWER_UPS.keys().pick_random()


func add_child_deferred(child_to_add, parent: Node2D) -> void:
	if is_instance_valid(parent):
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


func create_powerup(start_pos: Vector2, pu_type: GameData.POWERUP_TYPE) -> void:
	var pu: Powerup = POWERUP_SCENE.instantiate()
	pu.global_position = start_pos
	pu.set_powerup_type(pu_type)
	call_add_child(pu, get_tree().current_scene)


func create_random_powerup(start_pos: Vector2) -> void:
	create_powerup(start_pos, get_random_powerup())
