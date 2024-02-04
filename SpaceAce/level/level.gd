extends Node2D
## Level : A common Space Ace level.


func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_key_pressed(KEY_Q):
		GameManager.load_main_scene()
	if Input.is_key_pressed(KEY_E):
		ObjectMaker.create_explosion(Vector2(100.0, 200.0))
	if Input.is_key_pressed(KEY_B):
		ObjectMaker.create_boom(Vector2(300.0, 150.0))
