extends Node2D
## Level : A common Space Ace level.


func _ready():
	ScoreManager.reset_score()


func _process(_delta):
	if Input.is_key_pressed(KEY_Q):
		GameManager.load_main_scene()
	if Input.is_action_just_pressed("test"):
		ObjectMaker.create_powerup(Vector2(200.0, 200.0), GameData.POWERUP_TYPE.SHIELD)
