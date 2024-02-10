class_name Bullet
extends Area2D

const BOOM: PackedScene = preload("res://boom/boom.tscn")
const SPEED: float = 580.0

## Normalized Vector between -1.0 and 1.0
var _dir_of_travel: Vector2 = Vector2.ZERO
var _target_position: Vector2 = Vector2.ZERO


func init(target: Vector2, start_pos: Vector2) -> void:
	_target_position = target
	_dir_of_travel = start_pos.direction_to(target)
	global_position = start_pos


func _ready():
	look_at(_target_position)


func _process(delta):
	position += SPEED * delta * _dir_of_travel


func create_boom() -> void:
	var boom = BOOM.instantiate()
	boom.global_position = global_position
	get_tree().root.add_child(boom)
	queue_free()


func _on_body_entered(body):
	create_boom()


func _on_timer_timeout():
	create_boom()
