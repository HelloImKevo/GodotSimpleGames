class_name LevelButton
extends NinePatchRect
## LevelButton : Simple square button that displays the Level Number and a Check Mark
## if the level has been completed by the player.


@onready var level_label = $LevelLabel
@onready var check_mark = $CheckMark

const GREEN_TEXTURE = preload("res://assets/green_panel.png")

var _level_number: String = "99"


func _ready():
	level_label.text = _level_number


func set_level_number(level_number: String) -> void:
	_level_number = level_number


func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("select"):
		texture = GREEN_TEXTURE
		print("Selected: ", _level_number)
		SignalManager.on_level_selected.emit(_level_number)
