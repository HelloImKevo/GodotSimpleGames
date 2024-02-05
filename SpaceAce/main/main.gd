extends Node2D
## Main : The Main Menu (Title) scene with PLAY and EXIT buttons.


@onready var music = $Music


func _ready():
	music.volume_db = SoundManager.get_sfx_volume()


func _on_play_button_pressed():
	GameManager.load_level_scene()


func _on_exit_button_pressed():
	get_tree().quit()
