extends CanvasLayer
## Main : Main menu screen. Press 'jump' to start the first level.


func _ready():
	# Resume game at default x1 speed.
	Engine.time_scale = 1


func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		GameManager.load_next_level_scene()
