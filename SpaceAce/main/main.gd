extends Node2D
## Main : The Main Menu (Title) scene with PLAY and EXIT buttons.


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_play_button_pressed():
	GameManager.load_level_scene()
