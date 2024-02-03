extends Node2D
## Level : A common Space Ace level.


func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_key_pressed(KEY_Q):
		GameManager.load_main_scene()
