class_name LevelButton
extends TextureButton
## LevelButton : level_button.gd
##
## A button that reflects the Memory Grid width x height. It has
## normal, hover, and pressed textures.


@onready var label = $Label
@onready var sound = $Sound


var _level_number: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func set_level_number(level_num: int) -> void:
	_level_number = level_num
	var l_data = GameManager.LEVELS[_level_number]
	label.text = "%sx%s" % [l_data.rows, l_data.cols]


func _on_pressed():
	SoundManager.play_button_click(sound)
