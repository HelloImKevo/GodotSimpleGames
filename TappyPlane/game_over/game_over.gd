extends Control


@onready var game_over_label = $GameOverLabel
@onready var press_space_label = $PressSpaceLabel
@onready var timer = $Timer


var _can_press_space: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	on_game_over()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _can_press_space == true:
		if Input.is_action_just_pressed("fly") == true:
			GameManager.load_main_scene()


func on_game_over() -> void:
	show()
	timer.start()


func run_sequence() -> void:
	# Show the 'Game Over' message for 2 seconds, then 'Press Space'.
	game_over_label.hide()
	press_space_label.show()
	_can_press_space = true


func _on_timer_timeout():
	run_sequence()
