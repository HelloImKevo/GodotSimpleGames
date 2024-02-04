class_name SaucerManager
extends Node2D
## SaucerManager : Spawns large Saucer enemies.


const WAIT_TIME: float = 10.0
const WAIT_VAR: float = 1.5

var saucer_scene: PackedScene = preload("res://enemies/saucer.tscn")

@onready var timer = $Timer
@onready var paths = $Paths.get_children()


func _ready():
	spawn_saucer()


func spawn_saucer() -> void:
	var p = paths.pick_random()
	var s = saucer_scene.instantiate()
	p.add_child(s)
	Utils.set_and_start_timer(timer, WAIT_TIME, WAIT_VAR)


func _on_timer_timeout():
	spawn_saucer()
