extends Control


@onready var high_score_label = $MC/HB/HighScoreLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	high_score_label.text = str(GameManager.get_high_score())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("fly") == true:
		GameManager.load_game_scene()
