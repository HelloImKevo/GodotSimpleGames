class_name Main
extends CanvasLayer
## Main : Main Menu level selection screen.

@onready var grid_container = $MC/VBoxContainer/GridContainer

const BUTTON_SCENE: PackedScene = preload("res://level_button/level_button.tscn")
const LEVEL_COLS: int = 6
const LEVEL_ROWS: int = 5


func _ready():
	setup_grid()


func setup_grid() -> void:
	for level in range(LEVEL_COLS * LEVEL_ROWS):
		var level_button: LevelButton = BUTTON_SCENE.instantiate()
		level_button.set_level_number(str(level + 1))
		grid_container.add_child(level_button)
