class_name MainScreen
extends Control
## MainScreen : main_screen.gd
##
## Main choreographer for the whole game. Responsible for level selection.


@export var level_button_scene: PackedScene

@onready var hb_levels = $VB/HBLevels


# Called when the node enters the scene tree for the first time.
func _ready():
	setup_grid()


func setup_grid() -> void:
	for level in GameManager.LEVELS:
		create_level_button(level)


func create_level_button(ln: int) -> void:
	var new_lb = level_button_scene.instantiate()
	hb_levels.add_child(new_lb)
	new_lb.set_level_number(ln)
