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
	label.text = "3x4"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
